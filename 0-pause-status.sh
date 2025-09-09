#!/bin/bash

# Check and unpause contract if needed - prep for demo

CONTRACT_ADDRESS="0xB9A538E720f7C05a7A4747A484C231c956920bef"
RPC_URL="https://little-quaint-general.ethereum-sepolia.quiknode.pro/66337f93248f6a62fd1c607cf70b5eb05bf1d18c"

# Load environment for private key
source .env

echo "Checking contract pause status..."
IS_PAUSED=$(cast call "$CONTRACT_ADDRESS" "paused()" --rpc-url "$RPC_URL")

if [ "$IS_PAUSED" = "0x0000000000000000000000000000000000000000000000000000000000000001" ]; then
    echo "✅ Contract is PAUSED - unpausing for demo..."
    cast send \
        --private-key "$PRIVATE_KEY" \
        --rpc-url "$RPC_URL" \
        "$CONTRACT_ADDRESS" \
        "unpause()" > /dev/null 2>&1
    echo "✅ Contract unpaused and ready"
else
    echo "✅ Contract is NOT paused - ready for demo"
fi