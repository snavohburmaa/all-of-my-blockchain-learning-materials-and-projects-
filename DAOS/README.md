# DAOS — Token-Voted DAO Governance

> On-chain governance where every transaction is proposal-driven and voted on by ERC20 token holders.

A minimal DAO built with [Foundry](https://getfoundry.sh) and [OpenZeppelin](https://openzeppelin.com/contracts/). Token holders propose, vote, and execute arbitrary transactions through a timelock. The **Box** contract is owned by the timelock, so only successful governance proposals can change its state.

---

## Description

- **DAO-controlled contracts** — Ownership of governed contracts (e.g. **Box**) is held by a **Timelock**, not a single address.
- **Proposal-based execution** — Every change the DAO wants to make must go through: **Propose → Vote → Queue → Execute**.
- **ERC20 voting** — Voting power comes from **OhBurmaa (OB)** governance tokens; holders delegate and vote on proposals.

---

## Features

- Governor with configurable voting delay, voting period, and quorum (4%)
- Timelock-enforced execution delay (e.g. 1 hour)
- ERC20Votes token with delegation
- Foundry tests covering the full governance flow

---

## Project Structure

```
src/
├── GovToken.sol     # ERC20Votes governance token (OhBurmaa)
├── MyGovernor.sol   # Governor + Timelock + Votes
├── TimeLock.sol     # TimelockController wrapper
└── Box.sol          # Example governed contract (store/get number)
test/
└── MyGover.test.t.sol
```

---

## Quick Start

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Clone and test
git clone <repo-url>
cd DAOS
forge install
forge test
```

---

## Tech Stack

- **Solidity** ^0.8.20  
- **Foundry** (forge, cast)  
- **OpenZeppelin Contracts** (Governor, TimelockController, ERC20Votes)

---

## Topics

`solidity` `ethereum` `evm` `dao` `governance` `erc20` `openzeppelin` `foundry` `timelock` `defi`

---

## License

MIT
