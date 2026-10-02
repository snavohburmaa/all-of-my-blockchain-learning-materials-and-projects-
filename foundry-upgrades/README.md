# Foundry UUPS Upgradeable Contracts

A simple example project demonstrating UUPS (Universal Upgradeable Proxy Standard) proxy pattern using Foundry and OpenZeppelin Contracts.

## Overview

This project implements an upgradeable smart contract system where:
- **BoxV1**: Initial implementation with a `getNumber()` function
- **BoxV2**: Upgraded version that adds a `setNumber()` function
- Both versions use the same proxy, allowing upgrades without losing state

## Project Structure

```
foundry-upgrades/
├── src/
│   ├── BoxV1.sol          # Initial implementation (version 1)
│   └── BoxV2.sol          # Upgraded implementation (version 2)
├── script/
│   ├── DeployBox.s.sol    # Deployment script
│   └── UpgradeBox.s.sol   # Upgrade script
├── test/
│   └── DeployAndUpgradeTest.t.sol  # Test suite
└── foundry.toml           # Foundry configuration
```

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Solidity ^0.8.19

## Installation

```bash
# Install dependencies
forge install

# Build the project
forge build
```

### Test

Run the test suite:

```bash
forge test
```

Or run with verbose output:

```bash
forge test -vvv
```

## How It Works

1. **Deployment**: `DeployBox` deploys the `BoxV1` implementation and creates an `ERC1967Proxy` that points to it. The proxy is initialized with an owner.

2. **Upgrade**: `UpgradeBox` deploys a new `BoxV2` implementation and upgrades the existing proxy to point to it. The upgrade is authorized by the owner.

3. **State Preservation**: Since the proxy storage is separate from the implementation, all state (like `number`) is preserved across upgrades.

## Key Features

- ✅ UUPS proxy pattern (upgradeable by implementation)
- ✅ Owner-based access control for upgrades
- ✅ State preservation across upgrades
- ✅ Comprehensive test coverage

## Contracts

### BoxV1
- `getNumber()`: Returns the stored number
- `version()`: Returns version 1
- `initialize(address)`: Initializes the contract with an owner

### BoxV2
- `getNumber()`: Returns the stored number (inherited)
- `setNumber(uint256)`: Sets a new number value
- `version()`: Returns version 2
- `_authorizeUpgrade(address)`: Authorizes upgrades (no restrictions in this example)

## Security Notes

**Important**: In production, always:
- Restrict `_authorizeUpgrade()` to only authorized addresses (e.g., using `onlyOwner`)
- Thoroughly test upgrades before deploying
- Use a multisig wallet for upgrade authorization
- Verify implementation contracts before upgrading

## License

MIT
