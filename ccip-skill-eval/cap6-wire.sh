#!/usr/bin/env bash
# Cap 6 — Phase B: wire the two BnM SkillEval pools together (ApplyChainUpdates on both chains).
# Tip: `export FOUNDRY_KEYSTORE_PASSWORD=...` first to avoid a prompt per step.
#   bash ccip-skill-eval/cap6-wire.sh
set -eo pipefail
cd "$(dirname "$0")/.."
source .env
EOA=0x4F8089d0AE682Da4Eb7227cfF049c09242c667e4
echo "=== ApplyChainUpdates (Sepolia -> Arbitrum) ==="
forge script script/ApplyChainUpdates.s.sol --rpc-url "$SEPOLIA_RPC_URL" --account myaccount --sender "$EOA" --broadcast
echo "=== ApplyChainUpdates (Arbitrum -> Sepolia) ==="
forge script script/ApplyChainUpdates.s.sol --rpc-url "$ARBITRUM_SEPOLIA_RPC_URL" --account myaccount --sender "$EOA" --broadcast
echo "=== Phase B wiring complete ==="
