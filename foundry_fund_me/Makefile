# Use 'make' to run these commands
-include .env

build:; forge build

test:; forge test -vvv

deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) \
		--private-key $(PRIVATE_KEY) --broadcast --verify \
		--etherscan-api-key $(ETHERSCAN_API_KEY) --chain sepolia -vvvv


