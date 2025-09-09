if [ "$(cast call 0xB9A538E720f7C05a7A4747A484C231c956920bef "paused()" --rpc-url https://little-quaint-general.ethereum-sepolia.quiknode.pro/66337f93248f6a62fd1c607cf70b5eb05bf1d18c)" = "0x0000000000000000000000000000000000000000000000000000000000000001" ]; then echo "Contract is PAUSED"; else echo "Contract is NOT paused"; fi       


