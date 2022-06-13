# Table of contents
- [Table of contents](#table-of-contents)
- [Submit Info](#submit-info)
    - [Hardhat setup](#hardhat-setup)
  - [Todo:](#todo)
    - [Assigment](#assigment)
  - [Steps:](#steps)
    - [upKeep notes](#upkeep-notes)
  - [Some pointers](#some-pointers)
    - [How does the upKeeper works?](#how-does-the-upkeeper-works)
- [Extra Explanation](#extra-explanation)
  - [Testing](#testing)


# Submit Info
contract adx2 SHORTER random template (rkby): 0x047E019F5060F4ECb290902B9D4fdE3E86Fae668

contract adx3 final deployemtn whit randomness implemented(rkby): 0xeBE28A9525DCb23192b20467757d491D176eeD4E

final adx contract I swear if this shit doesn't work I'll kill someone for the love of your fucking stupid god: 

email: vip.hd777@gmail.com

Metamask adx: 0x9f83523C25aC79Be71ea16F303c38FA7b792A5e8

repo: 

Copy of random repo: 0x170855d134c64C12D971883C249603d6f7AB2610

Last timestamp: 1654899554

Latest price: 2908609414119


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
**contract is in automanic/**
[add randomness]()


## Testing
[All methods to test](https://ethereum-waffle.readthedocs.io/en/latest/matchers.html)