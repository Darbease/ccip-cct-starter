#!/usr/bin/env bash
# Cap 1 eval — skill-driven CCIP transfer: 0.0001 BnM (our CCT) Sepolia -> Arbitrum Sepolia, LINK fee.
# Run in your terminal (keystore password prompt needs a TTY):
#   bash ccip-skill-eval/send-cap1.sh
set -eo pipefail
cd "$(dirname "$0")/.."
source .env
npx -y @chainlink/ccip-cli send \
  --source ethereum-testnet-sepolia \
  --dest ethereum-testnet-sepolia-arbitrum-1 \
  --router 0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59 \
  --to 0x4F8089d0AE682Da4Eb7227cfF049c09242c667e4 \
  --fee-token LINK \
  --transfer-tokens 0x6F644Dd5d6675Cee778BAe9022E4546a7aE7F0c4=0.0001 \
  --wallet foundry:myaccount \
  --rpcs "$SEPOLIA_RPC_URL" "$ARBITRUM_SEPOLIA_RPC_URL"
