// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
// Chainlink Imports
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// This import includes functions from both ./KeeperBase.sol and
// ./interfaces/KeeperCompatibleInterface.sol
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

// Dev imports
import "hardhat/console.sol";


contract BullBear is ERC721, ERC721Enumerable, ERC721URIStorage, KeeperCompatibleInterface, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    //How we make a connection to Chainlink's contract to get the price feed
    AggregatorV3Interface public priceFeed;
    
    //Use an interval in seconds and a timestamp to slow execution of Upkeep
    uint public /* immutable */ interval; 
    uint public lastTimeStamp;

    int256 public currentPrice;
    
    // IPFS URIs for the dynamic nft graphics/metadata.
    string[3] bullUrisIpfs = [
        "https://ipfs.io/ipfs/Qmc3ueexsATjqwpSVJNxmdf2hStWuhSByHtHK5fyJ3R2xb?filename=simple_bull.json",
        "https://ipfs.io/ipfs/QmS1v9jRYvgikKQD6RrssSKiBTBH3szDK6wzRWF4QBvunR?filename=gamer_bull.json",
        "https://ipfs.io/ipfs/QmRsTqwTXXkV8rFAT4XsNPDkdZs5WxUx9E5KwFaVfYWjMv?filename=party_bull.json"
    ];

    string[3] bearUrisIpfs = [
        "https://ipfs.io/ipfs/QmZVfjuDiUfvxPM7qAvq8Umk3eHyVh7YTbFon973srwFMD?filename=simple_bear.json",
        "https://ipfs.io/ipfs/QmQMqVUHjCAxeFNE9eUxf89H1b7LpdzhvQZ8TXnj4FPuX1?filename=beanie_bear.json",
        "https://ipfs.io/ipfs/QmP2v34MVdoxLSFj1LbGW261fvLcoAsnJWHaBK238hWnHJ?filename=coolio_bear.json"
    ];

    event TokensUpdated(string marketTrend);

    // For testing with the mock on Rinkeby, pass in 10(seconds) for `updateInterval` and the address of my 
    // deployed  MockPriceFeed.sol contract (0xD753A1c190091368EaC67bbF3Ee5bAEd265aC420).
    constructor(uint _updateInterval, address _pricefeed) ERC721("Bull&Bear", "BBTK") {
        // Set the keeper update interval
        interval = _updateInterval;
        lastTimeStamp = block.timestamp;

        // set the price feed address to
        // BTC/USD Price Feed Contract Address on Rinkeby: https://rinkeby.etherscan.io/address/0xECe365B379E1dD183B20fc5f022230C044d51404
        // or the MockPriceFeed Contract: 
        priceFeed = AggregatorV3Interface(_pricefeed); // To pass in the mock

        // set the price for the chosen currency pair.
        currentPrice = getLatestPrice();
    }


    function safeMint(address _to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();//first increment then mint to avoid reentrancy attack! :3
        _safeMint(_to, tokenId);

        //Default URI: simple bull NFT img
        string memory defaultUri = bullUrisIpfs[0];
        _setTokenURI(tokenId, defaultUri);
    }


    //This functions runs off-chain, so it's good to make some intesnive calculations or random generation
    function checkUpkeep(bytes calldata /*checkData*/) 
    external view override 
    returns(bool upkeepNeeded, bytes memory /*performData*/) {
        //enough time passed since the last perform upKepp call or contract deployment
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
    }


    function performUpkeep(bytes calldata /*upkeepNeeded*/) external override {
        if ((block.timestamp - lastTimeStamp) > interval) {
            lastTimeStamp = block.timestamp;
            int latestPrice = getLatestPrice();

            if (latestPrice == currentPrice) {
                return;
            }
            else if (latestPrice < currentPrice) {
                //change current nft for a new BEAR img
                //false == lower
                updateAllTokenUris("bear");
            }
            else {
                //change current nft for a new BULL img
                //true == higher
                updateAllTokenUris("bull");
            }
        //update BTC/USD price
        currentPrice = latestPrice; 
        } 
        else {
            //this should never be triggered since checkUpKeep() won't allow it, but it's best practice
            return;
        }
    }


    function getLatestPrice() public view returns (int) {
         (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();

        return price;
    }


    function updateAllTokenUris(string memory _trend)internal {
        //!add random number here
        uint randomUint = 0;

        if (compareStrings(_trend, "bear")) {
            //the tendency is bearish
            for(uint i = 0; i < _tokenIdCounter.current(); i++){ 
                _setTokenURI(i, bearUrisIpfs[randomUint]);
            }
        }
        else {
            //the tendency is bullish
            for(uint i = 0; i < _tokenIdCounter.current(); i++){ 
                _setTokenURI(i, bullUrisIpfs[randomUint]);
            }
        }

        emit TokensUpdated(_trend);
    }


    /***
    * HELPERS
    ***/
    function compareStrings(string memory str1, string memory str2)
    internal pure 
    returns(bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }


    function setPriceFeed(address _newAddress) public onlyOwner {
        priceFeed = AggregatorV3Interface(_newAddress);
    }


    //!remove later, only for debug
    function setInterval(uint _newInterval) public onlyOwner {
        interval = _newInterval;
    }


    /*** 
    * The following functions are overrides required by Solidity
    ***/

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
