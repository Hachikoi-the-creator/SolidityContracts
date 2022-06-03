# Table of contents
- [Table of contents](#table-of-contents)
  - [Contract deployment Adx](#contract-deployment-adx)
  - [Page to solve connection issues](#page-to-solve-connection-issues)
  - [Steps](#steps)
    - [Get mumbai in your metamask](#get-mumbai-in-your-metamask)
    - [setup a Hardhat project](#setup-a-hardhat-project)
    - [Add mumbai & etherscan to hardhat.config.js](#add-mumbai--etherscan-to-hardhatconfigjs)
    - [Make the contract hehe](#make-the-contract-hehe)
    - [Deploy to Mumbai](#deploy-to-mumbai)
  - [How to update NFT's?](#how-to-update-nfts)
  - [CHALLENGES](#challenges)


## Contract deployment Adx
- 0xEec76d16F6587c6c1c114596A213c4Ba2D044633


## Page to solve connection issues
[life saver](https://chainlist.org/)


## Steps
### Get mumbai in your metamask
Just go to [this page](https://mumbai.polygonscan.com/), at the bottom there's an option to add it to your allet, just click yes lol
**Dont forget that you also need some MATIC for gas [here](https://mumbaifaucet.com/) or [here](https://faucet.polygon.technology/)**


### setup a Hardhat project
It does indeed work on windows!
- npm init -y
- yarn add hardhat
- npx hardhat init
- yarn add @openzeppelin/contracts
- yarn add @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers

### Add mumbai & etherscan to hardhat.config.js
```js
module.exports = {
  solidity: "0.8.10",
  networks: {
    mumbai: {
      url: process.env.TESTNET_RPC,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
   etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY
  },
};
```

### Make the contract hehe
Functions
- generateCharacter: Generates & update the svg of our NFT
- getLevels: Get the current level of an NFT (by ID)
- getTokenURI: Get the token URI of an NFT
- mint: mint NFT's
- train: train a given NFT and raise it's level, thus changing svg linked to it

### Deploy to Mumbai
Make the `deploy.js` file and add 
```js
etherscan: {
  apiKey: {
    polygonMumbai: process.env.POLYGONSCAN_API_KEY,
  },
},
```
to `hardhat.config.js`

- deploy the contract **save the address**
- send a confimation request of the contract's code! `$ npx hardhat verify --network mumbai CONTRAC_ADDRESS`
- play around whit the functions [here](https://mumbai.polygonscan.com)
- *Should update itself in OpenSea after asking for a metadata update*


## How to update NFT's?
[Online converter](https://base64.guru/converter/encode/image/svg)

Beyond just using the train method and chaning something like the link asociated whit it, you can transform an SVG -> Base64 data, [example](data:image/svg+xml;base64,IDxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiBwcmVzZXJ2ZUFzcGVjdFJhdGlvPSJ4TWluWU1pbiBtZWV0IiB2aWV3Qm94PSIwIDAgMzUwIDM1MCI+CiAgICAgICAgPHN0eWxlPi5iYXNlIHsgZmlsbDogd2hpdGU7IGZvbnQtZmFtaWx5OiBzZXJpZjsgZm9udC1zaXplOiAxNHB4OyB9PC9zdHlsZT4KICAgICAgICA8cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJibGFjayIgLz4KICAgICAgICA8dGV4dCB4PSI1MCUiIHk9IjQwJSIgY2xhc3M9ImJhc2UiIGRvbWluYW50LWJhc2VsaW5lPSJtaWRkbGUiIHRleHQtYW5jaG9yPSJtaWRkbGUiPldhcnJpb3I8L3RleHQ+CiAgICAgICAgPHRleHQgeD0iNTAlIiB5PSI1MCUiIGNsYXNzPSJiYXNlIiBkb21pbmFudC1iYXNlbGluZT0ibWlkZGxlIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIj5MZXZlbHM6IGdldExldmVscyh0b2tlbklkKTwvdGV4dD4KICAgICAgICA8L3N2Zz4=) Where this link has basically 2 parts, the kind of data there is (data:image/svg+xml;base64), and the actuall data (the giant string of numbers and letters)


## CHALLENGES
- Instead of only track the level, track hp, mp, charisma, sex, respect, lvl
- add some random numbers