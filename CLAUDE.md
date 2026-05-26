# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A Foundry-based collection of scripts for deploying and configuring Chainlink CCIP 1.5 Cross-Chain Tokens (CCT) and their token pools across testnets. This is a script-driven operations repo, not a library: `src/` holds only the deployable token contract, and there is **no test suite** — the workflow is running `forge script` against live testnets in a fixed sequence.

Adapted/simplified from [smartcontractkit/smart-contract-examples](https://github.com/smartcontractkit/smart-contract-examples). See README.md for the full step-by-step tutorial.

## Commands

```bash
forge build              # compile
forge fmt                # format Solidity

# Scripts run against live testnets and follow the ordered workflow below.
# All scripts take the same flags; --account/--sender use a cast keystore (never raw keys).
forge script script/<Name>.s.sol \
  --rpc-url $SEPOLIA_RPC_URL --account <keystore-name> --sender <address> --broadcast
```

Environment variables (copy `.env.example` → `.env`, then `source .env`): `SEPOLIA_RPC_URL`, `ARBITRUM_SEPOLIA_RPC_URL`, `ETHERSCAN_API_KEY`, `ARBISCAN_API_KEY`.

## Deployment workflow (order matters)

Scripts are stateful and chained — each reads the JSON artifacts written by earlier steps. The sequence must run **on both the source and destination chains** before cross-chain transfers work:

1. `DeployToken` → `DeployBurnMintTokenPool` (or `DeployLockReleaseTokenPool`)
2. `ClaimAdmin` → `AcceptAdminRole` → `SetPool` (registers token with the CCIP TokenAdminRegistry)
3. `ApplyChainUpdates` (wires the local pool to the remote pool/token)
4. `MintTokens` → `TransferTokens`

Other scripts are operational/admin helpers (rate limits, allowlists, remote-pool add/remove, admin-role transfer, config readers).

## Architecture

**Config in, artifacts out.** Scripts have no hardcoded per-deployment values. They read inputs from `script/config.json` and write deployed addresses to `script/output/deployed{Token,TokenPool}_<chainName>.json`. Downstream scripts read those output files back in. When editing or adding a script, preserve this read-config / write-output contract — breaking the JSON key naming (`deployedToken_<chainName>`, `deployedTokenPool_<chainName>`) breaks the chain.

- **`script/config.json`** — single source of token params (name, symbol, decimals, maxSupply, `withGetCCIPAdmin`, `ccipAdminAddress`), amounts to mint/transfer, `feeType` (`"link"` or `"native"`), and `remoteChains` (maps current chainId → its remote chainId for the current lane).
- **`script/HelperConfig.s.sol`** — hardcoded CCIP infrastructure addresses (router, RMN proxy, TokenAdminRegistry, RegistryModuleOwnerCustom, LINK, chain selector) per supported network, selected by `block.chainid`. Add a new chain here AND in `HelperUtils.getChainName`/`getNetworkConfig`.
- **`script/utils/HelperUtils.s.sol`** — JSON read helpers (`getAddressFromJson`, etc.), `chainId`↔name mapping, and string/bytes utilities. The JSON helpers are how scripts pass data between steps.
- **`src/Dependencies.sol`** — exists only to force-compile Chainlink CCIP contracts (pools, registries) so their artifacts/ABIs are available; it has no logic.
- **`src/BurnMintERC677WithCCIPAdmin.sol`** — the BnM token variant used when `withGetCCIPAdmin: true`; otherwise plain `BurnMintERC677` from the Chainlink lib is deployed.

**Supported chains** (chainId): Ethereum Sepolia `11155111`, Arbitrum Sepolia `421614`, Avalanche Fuji `43113`, Base Sepolia `84532`. A chain is only usable if present in both `HelperConfig` and `HelperUtils`.

## Conventions

- Solidity `0.8.24`; CCIP contracts imported via the `@chainlink/contracts-ccip/` remapping (→ `lib/ccip/contracts/`). `lib/ccip` and `lib/forge-std` are git submodules — run `forge install` / `git submodule update --init` after cloning.
- `foundry.toml` grants `fs_permissions` read-write on `./` so scripts can read `config.json` and write to `output/`.
