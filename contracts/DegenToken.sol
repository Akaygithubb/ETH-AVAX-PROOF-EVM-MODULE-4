// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    uint256 public constant SWORD_REDEMPTION_RATE = 100;
    uint256 public constant SHIELD_REDEMPTION_RATE = 150;

    enum ItemType { SWORD, SHIELD }

    mapping(address => uint256) public swordsOwned;
    mapping(address => uint256) public shieldsOwned;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        _mint(msg.sender, 10 * (10 ** uint256(decimals())));
    }

    function redeemItems(ItemType itemType, uint256 quantity) public {
        uint256 cost;
        if (itemType == ItemType.SWORD) {
            cost = SWORD_REDEMPTION_RATE * quantity;
            require(balanceOf(msg.sender) >= cost, "Not enough tokens to redeem for swords");
            swordsOwned[msg.sender] += quantity;
        } else if (itemType == ItemType.SHIELD) {
            cost = SHIELD_REDEMPTION_RATE * quantity;
            require(balanceOf(msg.sender) >= cost, "Not enough tokens to redeem for shields");
            shieldsOwned[msg.sender] += quantity;
        } else {
            revert("Invalid item type");
        }
        _burn(msg.sender, cost);
    }

    function checkSwordsOwned(address user) public view returns (uint256) {
        return swordsOwned[user];
    }

    function checkShieldsOwned(address user) public view returns (uint256) {
        return shieldsOwned[user];
    }

    function mintTokens(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Not enough tokens to burn");
        _burn(msg.sender, amount);
    }

    function transferTokens(address to, uint256 amount) public {
        require(to != address(0), "Invalid address");
        require(balanceOf(msg.sender) >= amount, "Not enough tokens to transfer");
        _transfer(msg.sender, to, amount);
    }
}
