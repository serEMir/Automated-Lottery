-include .env

.PHONY: all test deploy

build :; forge build

test :; forge test

install :; forge install cyfrin/foundry-devops@0.3.2 --no-commit && forge install smartcontractkit/chainlink-brownie-contracts@1.3.0 --no-commit && forge install foundry-rs/forge-std@v1.9.6 --no-commit && forge install transmissions11/solmate@v6.8.0 --no-commit

deploy-sepolia:
	@forge script script/DeployRaffle.s.sol:DeployRaffle --rpc-url $(SEPOLIA_RPC_URL) --account $(ACCOUNT) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv