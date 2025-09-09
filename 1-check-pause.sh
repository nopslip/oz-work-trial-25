#!/bin/bash

# Simple pause status check - no modifications

CONTRACT_ADDRESS="0xB9A538E720f7C05a7A4747A484C231c956920bef"
RPC_URL="https://little-quaint-general.ethereum-sepolia.quiknode.pro/66337f93248f6a62fd1c607cf70b5eb05bf1d18c"

echo "================================================"
echo "🔍 Contract Pause Status Check"
echo "================================================"
echo ""
echo "Contract: $CONTRACT_ADDRESS"
echo "Network: Sepolia"
echo ""

IS_PAUSED=$(cast call "$CONTRACT_ADDRESS" "paused()" --rpc-url "$RPC_URL")

if [ "$IS_PAUSED" = "0x0000000000000000000000000000000000000000000000000000000000000001" ]; then
    echo "🛑 Contract is PAUSED"
else
    echo "✅ Contract is NOT paused (active)"
fi
echo ""
echo "================================================"