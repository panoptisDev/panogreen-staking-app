// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Staking is ReentrancyGuard, Ownable {
    using SafeMath for uint256;

    IERC20 public s_stakingToken;
    IERC20 public s_rewardToken;

    // state variables
    uint256 public rewardRate = uint256(1e18) / (60 * 60 * 60 * 60);

    uint256 private totalStakedTokens;
    uint256 public rewardPerTokenStored;
    uint256 public lastUpdateTime;

    // mappings
    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public rewards;
    mapping(address => uint256) public userRewardPerTokenPaid;

    // events
    event Staked(address indexed user, uint256 indexed amount);
    event Withdrawn(address indexed user, uint256 indexed amount);
    event RewardsClaimed(address indexed user, uint256 indexed amount);
    event RewardRateUpdated(uint256 newRewardRate);

    // constructor
    constructor(address stakingToken, address rewardToken, address initialOwner) Ownable(initialOwner) {
        s_stakingToken = IERC20(stakingToken);
        s_rewardToken = IERC20(rewardToken);
    }

    // modifiers
    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;
        rewards[account] = earned(account);
        userRewardPerTokenPaid[account] = rewardPerTokenStored;
        _;
    }

    // This function calculates the reward per token. If no tokens are staked, it simply returns the stored reward per token.
    // Otherwise, it calculates the total rewards generated since the last update and divides it by the total staked tokens.
    function rewardPerToken() public view returns (uint256) {
        if (totalStakedTokens == 0) {
            return rewardPerTokenStored;
        }
        uint256 totalTime = block.timestamp.sub(lastUpdateTime);
        uint256 totalRewards = rewardRate.mul(totalTime);
        return rewardPerTokenStored.add(totalRewards.mul(1e18).div(totalStakedTokens));
    }
     // This function calculates the earned rewards for a specific account. It takes into account the staked balance of the account,
     // the difference between the current and paid reward per token, and the stored rewards.
    function earned(address account) public view returns (uint256) {
        return stakedBalance[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
    }
     // This function allows a user to stake a certain amount of tokens. The staked balance and total staked tokens are updated,
     // and a Staked event is emitted. The tokens are then transferred from the user to the contract.
    function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
        require(amount > 0, "Amount must be greater than zero");
        totalStakedTokens = totalStakedTokens.add(amount);
        stakedBalance[msg.sender] = stakedBalance[msg.sender].add(amount);
        emit Staked(msg.sender, amount);
        require(s_stakingToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");
    }
     // This function allows a user to withdraw staked tokens. The staked balance and total staked tokens are updated,
     // and a Withdrawn event is emitted. The tokens are then transferred from the contract to the user.
    function withdrawStakedTokens(uint256 amount) external nonReentrant updateReward(msg.sender) {
        require(amount > 0, "Amount must be greater than zero");
        require(stakedBalance[msg.sender] >= amount, "Insufficient staked amount");
        totalStakedTokens = totalStakedTokens.sub(amount);
        stakedBalance[msg.sender] = stakedBalance[msg.sender].sub(amount);
        emit Withdrawn(msg.sender, amount);
        require(s_stakingToken.transfer(msg.sender, amount), "Transfer failed");
    }
     // This function allows a user to claim their rewards. The rewards are set to zero, a RewardsClaimed event is emitted,
     // and the reward tokens are transferred from the contract to the user.
    function getReward() external nonReentrant updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards to claim");
        rewards[msg.sender] = 0;
        emit RewardsClaimed(msg.sender, reward);
        require(s_rewardToken.transfer(msg.sender, reward), "Transfer failed");
    }
    // This function allows the owner of the contract to update the reward rate. A RewardRateUpdated event is emitted.
    function updateRewardRate(uint256 newRewardRate) external onlyOwner {
        rewardRate = newRewardRate;
        emit RewardRateUpdated(newRewardRate);
    }
}