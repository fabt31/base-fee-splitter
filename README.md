# base-fee-splitter

> Protocol Fee Splitter for Base L2

Automatically split protocol revenue between multiple beneficiaries. Supports dynamic allocations, buyback-and-burn, staker distributions, and treasury funding — all on-chain.

## Features
- 💰 Auto-split ETH and ERC20 protocol fees
- 🔥 Buyback-and-burn integration (Uniswap v3)
- 🏦 Treasury allocation
- 👥 Staker revenue sharing
- ⚙️ Governance-adjustable split ratios
- 📊 Revenue analytics dashboard

## Split Configuration
```solidity
// Example: 40% stakers, 30% treasury, 20% buyback-burn, 10% team
FeeSplitter.setAllocations([
    Allocation(stakerContract, 4000),
    Allocation(treasury, 3000),
    Allocation(buybackContract, 2000),
    Allocation(teamMultisig, 1000),
]);
```

## Installation
```bash
forge install && forge build && forge test
```

## License
MIT