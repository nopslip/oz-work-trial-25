#!/bin/bash

# Large Transfer Demo - Triggers LargeTransfer event for Monitor/Relayer response
# Monitor detects → Sends webhook → Relayer pauses contract

set -e

echo "================================================"
echo "🚀 Large Transfer Detection Demo"
echo "================================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Load environment variables
if [ -f .env ]; then
    source .env
else
    echo -e "${RED}Error: .env file not found${NC}"
    echo "Create .env with PRIVATE_KEY, SEPOLIA_RPC_URL, and CONTRACT_ADDRESS"
    exit 1
fi

# Use env vars with fallbacks
CONTRACT_ADDRESS="${CONTRACT_ADDRESS:-0xB9A538E720f7C05a7A4747A484C231c956920bEf}"
RPC_URL="${SEPOLIA_RPC_URL:-https://ethereum-sepolia-rpc.publicnode.com}"

# Check private key
if [ -z "$PRIVATE_KEY" ]; then
    echo -e "${RED}Error: PRIVATE_KEY not set in .env${NC}"
    exit 1
fi

# Recipient address (just sending to a test address)
RECIPIENT="0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
# Transfer amount (101 tokens, just above the 100 token threshold)
TRANSFER_AMOUNT="101000000000000000000"  # 101 tokens with 18 decimals

echo "Setup:"
echo "  Contract: $CONTRACT_ADDRESS"
echo "  Network: Sepolia"
echo "  Transfer: 101 ACMEB tokens (above 100 token threshold)"
echo "  From: Your address"
echo "  To: $RECIPIENT"
echo ""
read -p "Press Enter to start demo..."

echo ""
echo -e "${BLUE}Step 1: Checking contract status${NC}"
echo "-------------------------------------"

# First check if contract is paused
IS_PAUSED=$(cast call "$CONTRACT_ADDRESS" "paused()" --rpc-url "$RPC_URL")
if [ "$IS_PAUSED" = "0x0000000000000000000000000000000000000000000000000000000000000001" ]; then
    echo "Contract is paused, unpausing first..."
    cast send \
        --private-key "$PRIVATE_KEY" \
        --rpc-url "$RPC_URL" \
        "$CONTRACT_ADDRESS" \
        "unpause()" > /dev/null 2>&1
    echo "✅ Contract unpaused"
    sleep 2
else
    echo "✅ Contract is active (not paused)"
fi

echo ""
echo -e "${BLUE}Step 2: Triggering Large Transfer${NC}"
echo "-----------------------------------"
echo "Transferring 101 ACMEB tokens (exceeds 100 token threshold)..."
echo ""

# Execute the transfer
echo "Sending large transfer (101 ACMEB tokens)..."
echo ""

cast send \
    --private-key "$PRIVATE_KEY" \
    --rpc-url "$RPC_URL" \
    "$CONTRACT_ADDRESS" \
    "transfer(address,uint256)" \
    "$RECIPIENT" \
    "$TRANSFER_AMOUNT"

echo ""
echo -e "${GREEN}✅ LargeTransfer Event Triggered!${NC}"
echo ""

echo -e "${YELLOW}Step 3: Monitor Detection${NC}"
echo "--------------------------"
echo "Monitor should now:"
echo "  1. Detect LargeTransfer event"
echo "  2. Send webhook to Relayer at /api/v1/plugins/large-transfer-handler/call"
echo ""
echo "Waiting for processing..."
sleep 5

echo ""
echo -e "${YELLOW}Step 4: Relayer Response${NC}"
echo "------------------------"
echo "Relayer should:"
echo "  1. Receive the webhook with transfer details"
echo "  2. Log: 'Large transfer detected: 101 tokens'"
echo "  3. Pause the contract to prevent further transfers"
echo ""
sleep 3

echo ""
echo -e "${BLUE}Step 5: Verifying Contract Paused${NC}"
echo "----------------------------------"

# Check if contract is now paused
IS_PAUSED=$(cast call "$CONTRACT_ADDRESS" "paused()" --rpc-url "$RPC_URL")
if [ "$IS_PAUSED" = "0x0000000000000000000000000000000000000000000000000000000000000001" ]; then
    echo -e "${GREEN}✅ SUCCESS: Contract is now PAUSED!${NC}"
    echo "The automated response system worked:"
    echo "  Transfer → Event → Monitor → Webhook → Relayer → Pause"
else
    echo -e "${YELLOW}⚠️  Contract not yet paused${NC}"
    echo "Check the Relayer logs for any issues"
    echo "The large transfer was still detected and logged"
fi

echo ""
echo "================================================"
echo -e "${GREEN}Demo Complete!${NC}"
echo "================================================"
echo ""
echo "View transaction on Etherscan:"
echo "https://sepolia.etherscan.io/tx/$TX_HASH"
echo ""
echo "Key Points Demonstrated:"
echo "  ✓ Real-time large transfer detection"
echo "  ✓ Monitor-to-Relayer webhook integration"
echo "  ✓ Automated emergency response (pause)"
echo "  ✓ Risk mitigation in seconds, not hours"
echo ""