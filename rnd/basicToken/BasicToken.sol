//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;


contract BasicToken {
    string public name = "The Coolest Token";
    string public symbol = "TCT";
    uint256 public immutable totalSupply;

    address public owner;
    mapping(address => uint256) balances;

    constructor(uint _totalSupply) {
        totalSupply = _totalSupply;
        balances[msg.sender] = totalSupply/2;
        owner = msg.sender;
    }


    function transferTo(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Not enough tokens");

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }


    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}