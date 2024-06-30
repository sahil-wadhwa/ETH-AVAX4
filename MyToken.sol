// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract DegenGaming {

    address public owner;

    // Token details
    string public tokenName = "Degen";
    string public symbol = "DGN";
    uint256 public totalSupply = 0;

    // Constructor
    constructor() {
        owner = msg.sender;
        rewards[0] = NFT("Spectrum", 1);
        rewards[1] = NFT("Radiant Crisis", 3);
        rewards[2] = NFT("RGX Bundle", 2);
    }


    // Mapping the address with their respective balance and NFT with the reward
    mapping(address => uint256) private balances;
    mapping(uint256 => NFT) public rewards;
    mapping(address => string[]) public redeemedItems;

    // NFT struct
    struct NFT {
        string name;
        uint256 price;
    }

    // Functions to mint, transfer, burn, check balance, and redeem rewards

    function mint(uint256 amount, address receiver) external  {
        require(msg.sender == owner, "Only the command center can mint new tokens");
        require(amount > 0, "Enter a valid amount");
        totalSupply += amount;
        balances[receiver] += amount;
    }

    

    function redeem(uint256 rewardID) external returns (string memory) {
        require(rewardID >= 0 && rewardID <= 2, "Invalid reward ID");
        require(rewards[rewardID].price <= balances[msg.sender], "Insufficient balance");

        redeemedItems[msg.sender].push(rewards[rewardID].name);
        balances[msg.sender] -= rewards[rewardID].price;
        totalSupply -= rewards[rewardID].price;
        return rewards[rewardID].name;
    }

    function getRedeemedItems(address user) external view returns (string[] memory) {
        return redeemedItems[user];
    }
    function transfer(uint256 amount, address receiver) external {
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
    }

    function burn(uint256 amount) external {
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        totalSupply -= amount;
    }

    function checkBalance(address user) external view returns (uint256) {
        return balances[user];
    }
}
