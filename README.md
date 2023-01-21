# ERC20 Foundry Tests

Repo to try testing contracts with foundry. The main contract to be tested is `./src/Token.sol`. Any other contracts being tested are extra.

## Development

Build

```
forge build
```

Test

```
forge test
```

Deploy

```
forge create \
    --rpc-url <your_rpc_url> \
    --constructor-args "Token" "TKN" \
    --private-key <your_private_key> \
    src/Token.sol:Token
```

Deploy with Frame.sh

```
forge create \
    --rpc-url http://127.0.0.1:1248 \
    --constructor-args "Token" "TKN" \
    --unlocked \
    --from <signer_address> \
    src/Token.sol:Token
```

Deploy and verify

```
forge create \
    ... \
    --etherscan-api-key <your_etherscan_api_key> \
    --verify
```

Verify

```
forge verify-contract \
    --chain-id <chain_id> \
    --num-of-optimizations <num_of_optimizations> \
    --watch \
    --constructor-args $(cast abi-encode "constructor(string,string)" "Token" "TKN") \
    <the_contract_address> \
    src/Token.sol:Token \
    <your_etherscan_api_key>
```
