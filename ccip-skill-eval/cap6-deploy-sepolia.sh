#!/usr/bin/env bash
# Cap 6 — Phase A (Sepolia): deploy + register the new BnM SkillEval CCT.
# Tip: `export FOUNDRY_KEYSTORE_PASSWORD=...` first to avoid a prompt per step.
#   bash ccip-skill-eval/cap6-deploy-sepolia.sh
set -eo pipefail
cd "$(dirname "$0")/.."
source .env
EOA=0x4F8089d0AE682Da4Eb7227cfF049c09242c667e4
RPC="$SEPOLIA_RPC_URL"
run() { echo "=== $1 (Sepolia) ==="; forge script "script/$1" --rpc-url "$RPC" --account myaccount --sender "$EOA" --broadcast; }
run DeployToken.s.sol
run DeployBurnMintTokenPool.s.sol
run ClaimAdmin.s.sol
run AcceptAdminRole.s.sol
run SetPool.s.sol
echo "=== Phase A Sepolia complete ==="
