/** Cap 1 fee preflight — read-only getFee for a small BnM transfer Sepolia -> Arb, LINK fee. */
import { EVMChain, networkInfo } from "@chainlink/ccip-sdk";

const SEPOLIA_RPC_URL = process.env.SEPOLIA_RPC_URL ?? "https://ethereum-sepolia-rpc.publicnode.com";
const ROUTER_SEPOLIA = "0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59";
const LINK_SEPOLIA = "0x779877A7B0D9E8603169DdbD7836e478b4624789";
const BNM_TOKEN_SEPOLIA = "0x6F644Dd5d6675Cee778BAe9022E4546a7aE7F0c4";
const RECEIVER = "0x4F8089d0AE682Da4Eb7227cfF049c09242c667e4";
const AMOUNT = 100000000000000n; // 0.0001 token (18 decimals)

async function main() {
  const source = await EVMChain.fromUrl(SEPOLIA_RPC_URL);
  const destChainSelector = networkInfo("ethereum-testnet-sepolia-arbitrum-1").chainSelector;
  const fee = await source.getFee({
    router: ROUTER_SEPOLIA,
    destChainSelector,
    message: {
      receiver: RECEIVER,
      tokenAmounts: [{ token: BNM_TOKEN_SEPOLIA, amount: AMOUNT }],
      extraArgs: { gasLimit: 0n, allowOutOfOrderExecution: true },
      feeToken: LINK_SEPOLIA,
    },
  });
  console.log("Fee (LINK juels):", fee.toString());
  console.log("Fee (LINK):", (Number(fee) / 1e18).toFixed(6));
}

main().catch((e) => { console.error(e); process.exit(1); });
