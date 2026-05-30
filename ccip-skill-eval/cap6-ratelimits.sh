#!/usr/bin/env bash
# Cap 6 — Rate limits (the CCT feature). Configure the Sepolia pool's limits for the Arbitrum lane:
# both directions ENABLED, capacity 10 BnMSE (10e18), refill 1 token/sec (1e18).
#   bash ccip-skill-eval/cap6-ratelimits.sh
set -eo pipefail
cd "$(dirname "$0")/.."
source .env
EOA=0x4F8089d0AE682Da4Eb7227cfF049c09242c667e4
POOL=0xC5815329cc5F02f1691458eA18ed1d3D461CB3f0   # Sepolia BnMSE pool
REMOTE_CHAIN_ID=421614                             # Arbitrum Sepolia
# run(address pool, uint256 remoteChainId, uint8 which[2=both],
#     bool outEn, uint128 outCap, uint128 outRate, bool inEn, uint128 inCap, uint128 inRate)
forge script script/UpdateRateLimiters.s.sol \
  --sig "run(address,uint256,uint8,bool,uint128,uint128,bool,uint128,uint128)" \
  "$POOL" "$REMOTE_CHAIN_ID" 2 \
  true 10000000000000000000 1000000000000000000 \
  true 10000000000000000000 1000000000000000000 \
  --rpc-url "$SEPOLIA_RPC_URL" --account myaccount --sender "$EOA" --broadcast
echo "=== Rate limits set on Sepolia pool for the Arbitrum lane ==="
