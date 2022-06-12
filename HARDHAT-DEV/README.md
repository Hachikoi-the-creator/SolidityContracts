# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

## Hardhard commands

- npx hardhat accounts
  - Prints all the development accounts

- npx hardhat compile
  - If not path is provided Compiles all the `.sol` files inside /contracts
  - If path is provided, only compiles that contract

- npx hardhat clean
  - dunno hehe
 
- npx hardhat test
  - If not path is provided runs all the `.js` files inside /test
  - If path is provided, only runs that  `.js` file
 
- npx hardhat node
  - Starts a local blockchain server whit 20 test accounts, **Use it along whit console.log() to have a better understanding on what could have been wrong and how (print, accounts balances, ect.)**
```c#
pragma solidity ^0.8.x;
import "hardhat/console.sol";

function transfer(address to, uint256 amount) external {
console.log("Sender balance is %s tokens", balances[msg.sender]);
console.log("Trying to send %s tokens to %s", amount, to);
}
```
 
- node scripts/sample-script.js
  - Run the `.js` file specified deploying the contract in the local blockchain server

- npx hardhat help
  - - -
