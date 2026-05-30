#!/usr/bin/env bash
# Cap 6 — final proof: mint BnMSE on Sepolia, then transfer it cross-chain to Arbitrum.
# Transfer amount (config tokenAmountToTransfer) is far below the 10-token rate-limit cap.
#   bash ccip-skill-eval/cap6-mint-transfer.sh
set -eo pipefail
cd "$(dirname "$0")/.."
source .env
EOA=0x4F8089d0AE682Da4Eb7227cfF049c09242c667e4
echo "=== MintTokens (Sepolia) ==="
forge script script/MintTokens.s.sol --rpc-url "$SEPOLIA_RPC_URL" --account myaccount --sender "$EOA" --broadcast
echo "=== TransferTokens (Sepolia -> Arbitrum) ==="
forge script script/TransferTokens.s.sol --rpc-url "$SEPOLIA_RPC_URL" --account myaccount --sender "$EOA" --broadcast
echo "=== Mint + transfer complete — grab the messageId / ccip.chain.link URL above ==="
