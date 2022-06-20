# Table of contents
- [Table of contents](#table-of-contents)
  - [Extra challenges](#extra-challenges)
  - [Hardhard commands](#hardhard-commands)


## Extra challenges
1. Update the interest mechanism in the Staker.sol contract so that you receive a "non-linear" amount of ETH based on the blocks between deposit and withdrawal.

2. Allow users to deposit any arbitrary amount of ETH into the smart contract, not just 0.5 ETH.

3. Instead of using the vanilla ExampleExternalContract contract, implement a function in Staker.sol that allows you to retrieve the ETH locked up in ExampleExternalContract and re-deposit it back into the Staker contract.
- Make sure to only "white-list" a single address to call this new function to gate its usage!.
- Make sure that you create logic/remove existing code to ensure that users are able to interact with the Staker contract over and over again! We want to be able to ping-pong from Staker -> ExampleExternalContract repeatedly!.

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
