// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/access/Ownable.sol";

contract AnnuToken is ERC20, Ownable {
    struct Item {
        string name;
        uint256 cost;
    }

    Item[] public annuRedeemableItems;
    mapping(address => mapping(uint256 => bool)) public annuItemRedeemed;

    constructor() ERC20("Annu", "ANNU") {
        initializeAnnuRedeemableItems();
    }

    function initializeAnnuRedeemableItems() internal {
        annuRedeemableItems.push(Item("Annu Item 1", 100));
        annuRedeemableItems.push(Item("Annu Item 2", 200));
        annuRedeemableItems.push(Item("Annu Item 3", 300));
        annuRedeemableItems.push(Item("Annu Item 4", 400));
    }

    function mintAnnuToken(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burnAnnuToken(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function transferAnnuTokens(address to, uint256 amount) external onlyOwner {
        _transfer(msg.sender, to, amount);
    }

    function redeemAnnuItem(uint256 itemId) external {
        require(itemId < annuRedeemableItems.length, "Annu Item does not exist");
        require(balanceOf(msg.sender) >= annuRedeemableItems[itemId].cost, "Insufficient Annu balance");
        require(!annuItemRedeemed[msg.sender][itemId], "Annu Item already redeemed");

        // Burn Annu tokens as payment for the redeemed item
        _burn(msg.sender, annuRedeemableItems[itemId].cost);

        // Mark Annu item as redeemed for the user
        annuItemRedeemed[msg.sender][itemId] = true;
    }

    function getAnnuRedeemedItems(address user) external view returns (bool[] memory) {
        bool[] memory redeemed = new bool[](annuRedeemableItems.length);
        for (uint256 i = 0; i < annuRedeemableItems.length; i++) {
            redeemed[i] = annuItemRedeemed[user][i];
        }
        return redeemed;
    }
}
