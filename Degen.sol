// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";

contract Degen is ERC20, Ownable {
    uint256[] internal itemIds;
    mapping(uint256 => Value) public items;
    mapping(address => uint256[]) public userItems;  

    struct Value {
        string name;
        uint256 cost;
    }

    constructor(address owner) ERC20("Degen", "DGN") Ownable(owner) {
        _mint(owner, 999);
    }

    function createItem(string memory _name, uint256 _cost) external onlyOwner {
        Value memory newItem = Value({name: _name, cost: _cost});
        items[itemIds.length] = newItem;
        itemIds.push(itemIds.length);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burnFrom(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }

    function transferTokens(address to, uint256 amount) external {
        _transfer(msg.sender, to, amount);
    }

    function checkTokenBalance(address account) external view returns (uint256) {
        return balanceOf(account);
    }

    function buyItem(address user, uint256 itemId) public  {

        uint256 user_balance = balanceOf(user);
        uint256 itemCost = items[itemId].cost;

        require(user_balance > itemCost, "You don't have enough tokens");
	itemMapper(user, itemId);
        
    }
    
    function itemMapper(address _user, uint256 _itemId) internal {
	userItems[_user].push(_itemId);
    }

    function getUserItems(address user) external view returns (uint256[] memory) {
        return userItems[user];
    }

}
