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
  - [half-way tru challenges](#half-way-tru-challenges)


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


## half-way tru challenges
```c#
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    //give superpowers to the uint256 (str -> uin256 & viceversa)
    using Strings for uint256;

    // modify the default counter object
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    string[6] constant respectStat = [
        "Low",
        "NotLow",
        "KindaGood",
        "Good",
        "MoreThanGood",
        "PrettyGood",
        "Amazing"
    ];
        
    

    string[7] constant speedMetric =[
        "Slow",
        "KindaSlow",
        "KindaFast",
        "Fast",
        "ReallyFast",
        "FastAF",
        "SPEED"
    ];


    // struct of all the props
    struct warriorStats {
        uint256 level;
        uint256 hp;
        uint8 respect;
        uint8 speed;
        bool gender;// true = male ; false = female
    }

    // Link an uint256 (NFTId), to the stats of the fighter
    mapping(uint256 => warriorStats) public tokenIdToLevel;

    constructor() ERC721("ChainBattles", "CBTS") {}

    /**
     * @dev
     * @param _tokenID keep track of the users by id's
     */
    function generateCharacter(uint256 _tokenId) public view returns (string memory) {
        //? annoying way to wrork whit json in Solidity unu
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Fighter",'</text>',
            '<text x="50%" y="45%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ",getLevel(_tokenId),'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "HP: ",getHP(_tokenId),'</text>',
            '<text x="50%" y="55%" class="base" dominant-baseline="middle" text-anchor="middle">', "Respect: ",getRespect(_tokenId),'</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(_tokenId),'</text>',
            '<text x="50%" y="65%" class="base" dominant-baseline="middle" text-anchor="middle">', "Gender: ",getGender(_tokenId),'</text>',
            '</svg>'
        );

        //? Convert the svg to Base64 code/text
        return string(abi.encodePacked("data:image/svg+xml;base64,",Base64.encode(svg)));
    }


    /**
     * @dev Get the level info
     * @param _tokenId keep track of the users by id's
     * @return string expected to be string
     */
    function getLevel(uint256 _tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevel[_tokenId];
        //? int256 -> String tnx to 'using Strings for uint256;'
        return levels.toString();
    }


    /**
     * @dev Get the level info
     * @param _tokenId keep track of the users by id's
     * @return string expected to be string
     */
    function getHP(uint256 _tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevel[_tokenId];
        //? int256 -> String tnx to 'using Strings for uint256;'
        return levels.toString();
    }


    /**
     * @dev Get the level info
     * @param _tokenId keep track of the users by id's
     * @return string expected to be string
     */
    function getRespect(uint256 _tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevel[_tokenId];
        //? int256 -> String tnx to 'using Strings for uint256;'
        return levels.toString();
    }


    /**
     * @dev Get the level info
     * @param _tokenId keep track of the users by id's
     * @return string expected to be string
     */
    function getSpeed(uint256 _tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevel[_tokenId];
        //? int256 -> String tnx to 'using Strings for uint256;'
        return levels.toString();
    }


    /**
     * @dev Get the level info
     * @param _tokenId keep track of the users by id's
     * @return string expected to be string
     */
    function getGender(uint256 _tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevel[_tokenId];
        //? int256 -> String tnx to 'using Strings for uint256;'
        return levels.toString();
    }


    /**
     * @dev
     * @param _tokenID keep track of the users by id's
     */
    function getTokenURI(uint256 _tokenId) public view returns (string memory) {
        // ? this is how solidity works whit JSON objects 💢
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',_tokenId.toString(),'",',
            '"description": "Battles on chain",',
            '"image": "',generateCharacter(_tokenId),'"',
            "}"
        );

        return string(abi.encodePacked(
            "data:application/json;base64,",Base64.encode(dataURI)));
    }


    /**
     * @dev Create a new NFT -> Initialize the level variable -> Set the token URI
     */
    //! add a require to avoid reseting the character a user could already have
    function mint() public {
        // +1 to the special variable type, Counter (modified)
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();

        /** function _safeMint() from the ERC721 specs
         * @param _toWhom the function needs to know to who will it send the NFT
         * @param _ID the minted NFT needs an unique ID
         */
        _safeMint(msg.sender, newItemId);

        /** @dev Create a new entry to the mapping and give it the value of 0*/
        tokenIdToLevel[newItemId] = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }


    /** 
     * @dev Checks if the current user owns an NFT (exist & it's the owner)
     * @param _tokenId way to keep track of the N of NFT's
     */
    function train(uint256 _tokenId) public {
        // ? functions from the ERC721 standard
        require(_exists(_tokenId));
        require(ownerOf(_tokenId) == msg.sender, "You must own this NFT to train it!");

        // update stats
        uint256 currentLevel = tokenIdToLevel[_tokenId];
        tokenIdToLevel[_tokenId] = currentLevel + 1;
        _setTokenURI(_tokenId, getTokenURI(_tokenId));

    }
}
```