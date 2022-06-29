# Table of contents
- [Table of contents](#table-of-contents)
  - [Deployments](#deployments)
  - [rnd src](#rnd-src)
  - [Hardhard commands](#hardhard-commands)

## Deployments
*IF the contract was uploaded whit Remix, optmization in hardhat.config must be false*

- Twitter clone Moralis VERIFIED - 0x4B0a24db3a6e5F5247a7868C02230f8F1ba0c9D1

## rnd src
- [Twitter clone moralis](https://www.youtube.com/watch?v=HrlpTJD_CF0)

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
