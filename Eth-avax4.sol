// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    struct Item {
        string name;
        uint256 cost;
    }

    Item[] public redeemableItems;
    mapping(address => mapping(uint256 => bool)) public itemRedeemed;

    constructor() ERC20("Degen", "DGN") {
        initializeRedeemableItems();
    }

    function initializeRedeemableItems() internal {
        redeemableItems.push(Item("Item 1", 100));
        redeemableItems.push(Item("Item 2", 200));
        redeemableItems.push(Item("Item 3", 300));
        redeemableItems.push(Item("Item 4", 400));
    }

    function mintToken(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burnToken(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function transferTokens(address to, uint256 amount) external onlyOwner {
        _transfer(msg.sender, to, amount);
    }

    function redeem(uint256 itemId) external {
        require(itemId < redeemableItems.length, "Item does not exist");
        require(balanceOf(msg.sender) >= redeemableItems[itemId].cost, "Insufficient balance");
        require(!itemRedeemed[msg.sender][itemId], "Item already redeemed");

        // Burn tokens as payment for the redeemed item
        _burn(msg.sender, redeemableItems[itemId].cost);
        
        // Mark item as redeemed for the user
        itemRedeemed[msg.sender][itemId] = true;
    }

    function getRedeemedItems(address user) external view returns (bool[] memory) {
        bool[] memory redeemed = new bool[](redeemableItems.length);
        for (uint256 i = 0; i < redeemableItems.length; i++) {
            redeemed[i] = itemRedeemed[user][i];
        }
        return redeemed;
    }
}
