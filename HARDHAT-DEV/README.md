# Table of contents
- [Table of contents](#table-of-contents)
- [Full steps](#full-steps)
  - [contract deployments](#contract-deployments)
  - [Hardhard commands](#hardhard-commands)


# Full steps
1. Create a basic contract whit contract wizard (ERC721, mintable, auto-increment id's, enumerable, URI storage)
2. Inside the contract create 2 fixed arrays whit the URI for the NFT's (.json files)
3. Add `KeeperCompatible` from chainlik (import it, and inherit from it)
4. Run a function to make a change in the callback from `KeeperCompatible`, as well as add a new param to the constructor (timeInterval) for the `KeeperCompatible`
5. **Alchemy** Create a new mumbai app, and copy the URL-like link on your .env, as well as your mumbai private key & your polygonscan API key
6. Create a deploy script (just modify the sample)
7. Deploy the contract `npx hardhat run scripts/YOUR_CONTRACT.sol --network mumbai`
8. verify your contract `npx hardhat verify --network mumbai YOUR_CONTRACT_ADDRESS YOUR_CONSTRUCTOR_ARGUMENT` [docs](https://hardhat.org/plugins/nomiclabs-hardhat-etherscan)
9. **Oracle stuff** Register a new upkeep once the contract has been validated [here](https://keepers.chain.link/mumbai/new)
10. [Mumbai LINK tokens](https://faucets.chain.link/mumbai)


## contract deployments
**BullBear whit secueantial auto-update**
- (mumbai, empty constructor VERIFIED) - 0x6371AbB68214A7a6964fdBcE17451a3180d493Ff
- (mumbai, constructor w/args VERIFIED) - 0x37c564cf66128C01f2fD05B2ce3611Fca4ee89D1

**Price consumer BTC/USD**
- (rinkeby, basic OK) 0x56cEa0E7ac41794568590BC1D6623F5E7599FA26

**Full price feed & automatic**
- (rinkeby, cons w/arg 300 VERIFIED) - 0xacFd0f27823296183E2e2017C457339358e00c60




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
