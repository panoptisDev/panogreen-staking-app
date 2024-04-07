# Token-Staking DApp

This application is delivered as is. There is a CSS error causing the wallet connect-button to render at the center right of the page instead of at the top right corner. I tried to fix it but couldn't figure it out. I hope someone can fix it and get back to me. Besides this, it works just fine. I hope you enjoy it and star my repo if you like it.

*[![Netlify Status](https://api.netlify.com/api/v1/badges/2d7d2668-2c07-4985-9658-a2f0463defa8/deploy-status)](https://app.netlify.com/sites/panogreenstake/deploys)
---
![Token-Staking DApp](src/assets/digistake1.jpg)

Token-Staking is a decentralized application (DApp) that allows users to stake a ERC20 token (new or old) and earn rewards. The staking process generates reward tokens on an hourly basis, rewarding users based on the amount and duration of their stake.

## Key Tokens

- **Stake Token:** This is an ERC20 token used for staking within the DApp. Users must approve this token for the staking contract before they can stake it.
- **Reward Token:** This is another ERC20 token that is generated hourly by the staking process. Users earn these tokens as rewards for staking their stake tokens.

## How to Use

1. Connect your wallet.
2. Stake your desired amount (e.g., 1 token).
3. Sit back and watch your rewards accumulate.
4. Remember, you can withdraw your staked amount and rewards at any time.

## Network Configuration

To configure the network, make the following changes in the `components/Navigation` directory:

- In `connectedNetwork.jsx`, set `chainId` to `11155111`.
- In `connectWallet.jsx`, set the following contract addresses:
  - `stakingContractAddress = "0x6B53d50d3b4400c5aC8e79847b2180a47cd20AD7"`
  - `stakeTokenContractAddress = "0xB2e6b82bF799f2369ACBdA2859e7b1F1A25E270f"`

## Contract Addresses

You need to approve staking contract for each token first before you can use them in the staking contract. Here are the contract addresses for the tokens and the staking contract on Sepolia:

- **StakeToken.sol (STT):** [0x4d0eE15866f17E4762478958c549d4E693A09376](https://sepolia.etherscan.io/address/0x4d0eE15866f17E4762478958c549d4E693A09376#code)
- **RewardToken.sol (RWT):** [0x1A91217F7dC8eb397f1CB29a479EFeE76Ce305cA](https://sepolia.etherscan.io/token/0x1A91217F7dC8eb397f1CB29a479EFeE76Ce305cA)
- **Staking.sol:** [0xf37894409dF321A66a2D9F167e5064b9B5C5da28](https://sepolia.etherscan.io/address/0xf37894409dF321A66a2D9F167e5064b9B5C5da28#code)

---

## When deploying token
Add for example 10000000 for ten million tokens, don't add eighteen extra zeros.

In the line `_mint(msg.sender, initialSupply * 10**18);`, the `initialSupply` is multiplied by `10**18` to account for the 18 decimal places that are standard for many ERC20 tokens. This means that if you pass `1` as the `initialSupply`, the contract will mint `1 * 10**18` tokens, which is `1` token with `18` decimal places.

## update reward rate
update reward rate and enter for example anumber of fifteen two´s 222222222222222 this means that the reward rate will be 0.00222222222222222 fifteen twos means that thre zeros goes infront since we are dealing with 18 decimal places.

## Reward Rate
The `Reward_Rate` in this contract is a constant that determines the rate at which rewards are distributed to users who stake their tokens. 

```solidity
uint256 public constant Reward_Rate = uint256 (1e18) / (60 * 60 * 60 * 60);
```

This rate is set to `1e18` (which represents 1 in Solidity when dealing with 18 decimal places, a common standard for many ERC20 tokens) divided by `60 * 60 * 60 * 60` (the number of seconds in 1000 hours). 

This means that for every second that passes, a user would theoretically earn `1/3600000` (approximately 0.000000277777778) of a token for each token they have staked, assuming the reward distribution is linear and uninterrupted. 

This rate is used in the `rewardPerToken` function to calculate the total rewards over a period of time:

```solidity
uint256 totalTime = block.timestamp.sub(lastUpdateTime);
uint256 totalRewards = Reward_Rate.mul(totalTime);
```

Here, `totalTime` is the amount of time that has passed since the last update, and `totalRewards` is the total amount of rewards earned over that period of time. 

Please note that the actual reward distribution would also depend on other factors such as the total amount of staked tokens and the specific implementation of the staking contract.
---
## APR on 1000 Tokens Staked for a Year
The Annual Percentage Rate (APR) for staking can be calculated based on the reward rate and the number of tokens staked. 

In this case, the reward rate is `1e18 / (60 * 60 * 60 * 60)`, which is approximately `0.000000277777778` tokens per second for each staked token.

To calculate the APR, we first calculate the total rewards for staking 1000 tokens for a year:

```python
tokens_staked = 1000
seconds_in_a_year = 60 * 60 * 24 * 365
reward_rate = 1e18 / (60 * 60 * 60 * 60)

total_rewards = tokens_staked * reward_rate * seconds_in_a_year
```

Then, we calculate the APR as a percentage of the initial stake:

```python
APR = (total_rewards / tokens_staked) * 100
```

This will give you the APR for staking 1000 tokens for a year. Please note that this calculation assumes that the reward distribution is linear and uninterrupted, and that the staking contract does not have any additional rules or fees that could affect the rewards.

## Modifying the Reward Rate
To double the `Reward_Rate` in your contract, you can simply multiply the current `Reward_Rate` by 2. 

However, you need to remove the `constant` keyword from the `Reward_Rate` declaration because constant variables cannot be modified after they have been declared. 

Here's how you can do it:

```solidity
uint256 public Reward_Rate = 2 * (uint256 (1e18) / (60 * 60 * 60 * 60));
```

This will double the current `Reward_Rate`. 

Please note that changing the reward rate will affect all future rewards. Also, be aware that this change could have other implications on contract's logic, so make sure to thoroughly test your contract after making this change.
