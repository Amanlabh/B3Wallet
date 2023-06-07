#!/usr/bin/env bash

# Install ckbtc locally as documented in:
# https://github.com/demergent-labs/azle/tree/main/examples/ckbtc

IC_VERSION=d6d395a480cd6986b4788f4aafffc5c03a07e46e

CKBTC_ID=mxzaz-hqaaa-aaaar-qaada-cai
KYY_ID=bkyz2-fmaaa-aaaaa-qaaaq-cai
MINTER_ID=mqygn-kiaaa-aaaar-qaadq-cai

curl -o wasm/ckbtc/ledger.wasm.gz "https://download.dfinity.systems/ic/$IC_VERSION/canisters/ic-icrc1-ledger.wasm.gz"
gunzip -f wasm/ckbtc/ledger.wasm.gz
curl -o wasm/ckbtc/ledger.did "https://raw.githubusercontent.com/dfinity/ic/$IC_VERSION/rs/rosetta-api/icrc1/ledger/ledger.did"

# Deploy ckbtc
dfx deploy ckbtc --specified-id "$CKBTC_ID" --argument="(variant { Init = record { minting_account = record { owner = principal \"$MINTER_ID\"}; transfer_fee = 0 : nat64; token_symbol = \""ckBTC"\"; token_name = \""ckBTC"\"; metadata = vec {}; initial_balances = vec {}; archive_options = record { num_blocks_to_archive = 0 : nat64; trigger_threshold = 0 : nat64; controller_id = principal \""aaaaa-aa"\"} } })"

curl -o wasm/kyt/kyt.wasm.gz "https://download.dfinity.systems/ic/$IC_VERSION/canisters/ic-ckbtc-kyt.wasm.gz"
gunzip -f wasm/kyt/kyt.wasm.gz
curl -o wasm/kyt/kyt.did "https://raw.githubusercontent.com/dfinity/ic/$IC_VERSION/rs/bitcoin/ckbtc/kyt/kyt.did"

# Deploy kyt (know your token)
dfx deploy kyt --specified-id "$KYY_ID" --argument "(variant { InitArg = record { minter_id = principal \"$MINTER_ID\"; maintainers = vec { principal \"$(dfx identity get-principal)\" }; mode = variant { AcceptAll } } })"
dfx canister call kyt set_api_key '(record { api_key = "" })'


curl -o wasm/minter/minter.wasm.gz "https://download.dfinity.systems/ic/$IC_VERSION/canisters/ic-ckbtc-minter.wasm.gz"
gunzip -f wasm/minter/minter.wasm.gz
curl -o wasm/minter/minter.did "https://raw.githubusercontent.com/dfinity/ic/$IC_VERSION/rs/bitcoin/ckbtc/minter/ckbtc_minter.did"

# Deploy minter
dfx deploy minter --specified-id "$MINTER_ID" --argument "(variant { Init = record {btc_network = variant { Regtest }; min_confirmations=opt 1; ledger_id = principal \"$CKBTC_ID\"; kyt_principal = opt principal \"$KYY_ID\"; ecdsa_key_name = \""dfx_test_key"\";retrieve_btc_min_amount = 5_000; max_time_in_queue_nanos = 420_000_000_000; mode = variant {GeneralAvailability}} })"
