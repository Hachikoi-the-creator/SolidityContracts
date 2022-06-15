# Table of contents
- [Table of contents](#table-of-contents)
- [Submit Info](#submit-info)
- [Full steps](#full-steps)
  - [contract deployments](#contract-deployments)
    - [Hardhat setup](#hardhat-setup)
  - [Todo:](#todo)
    - [Assigment](#assigment)
  - [Steps:](#steps)
    - [upKeep notes](#upkeep-notes)
  - [Some pointers](#some-pointers)
    - [How does the upKeeper works?](#how-does-the-upkeeper-works)
- [Extra Explanation](#extra-explanation)
  - [Testing](#testing)
- [Pages used](#pages-used)


# Submit Info
contract adx2 SHORTER random template (rkby): 0x047E019F5060F4ECb290902B9D4fdE3E86Fae668

contract adx3 final deployemtn whit randomness implemented(rkby): 0xeBE28A9525DCb23192b20467757d491D176eeD4E


email: vip.hd777@gmail.com

Metamask adx: 0x9f83523C25aC79Be71ea16F303c38FA7b792A5e8

repo: 

Copy of random repo: 0x170855d134c64C12D971883C249603d6f7AB2610

Last timestamp: 1654899554

Latest price: 2908609414119


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



### Hardhat setup
- npm init -y
- yarn add hardhat
- npx hardhat init
- yarn add  @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers
- yarn add  @openzeppelin/contracts @chainlink/contracts


## Todo:
- Make the array if strings, a fixed array, and a constant
### Assigment
- add randomness (chainlink docs, EVM stuff)
  - How does VRF Work?
    - You need to link the contract and the chainlink subscription
      - in the contract put the correct subscription ID, and in the subscription add the address of the contract once it has ben deployed
    - Use the function `requestRandomWords()` and **wait** for the response from chainlink!
- 


## Steps:
- Using the openZeppelli contract wizard, create and ERC721 (Mintable:AutoincrementIds, Enumerable, URIStorage)
- Test it in the Remix enviroment or whit Hardhat.

```c#
// SPDX-License-Identifier: MIT

pragma solidity ^0.6.4;

import "@chainlink/contracts/src/v0.6/tests/MockV3Aggregator.sol";
```


### upKeep notes
- when testing set th gas limit to 50k and 5-7 LINK
- when deploying set it to 5k and 10-20 LINK


## Some pointers
- price must be an `int` since uint don't work whit decimals

### How does the upKeeper works?
It calls our contract everytime a block in chain is mined, the our contract only makes changes if the interval condition is meet!


# Extra Explanation
[get pair's prices](https://docs.chain.link/docs/get-the-latest-price/)
**Contract is in aggregator/PriceConsumer.sol**
This makes a request to the chainlink Oracle to get the price of the given pair, view docs to get a different pair or tesnet.

[contract automatization](https://docs.chain.link/docs/chainlink-keepers/introduction/)
**contract is in autoupdate-secuential-change/Counter**


## Testing
[All methods to test](https://ethereum-waffle.readthedocs.io/en/latest/matchers.html)

# Pages used
[keepers automatic contract](https://keepers.chain.link/)
[data from external world](https://docs.chain.link/docs/get-the-latest-price/)
[data feeds index](https://docs.chain.link/docs/reference-contracts/)
