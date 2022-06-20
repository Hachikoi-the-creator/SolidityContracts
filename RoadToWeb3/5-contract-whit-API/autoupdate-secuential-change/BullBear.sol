// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

// open zeppelin standards
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// chain.link for automated updates
//automatic
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";
//price feed
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract BullBear is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable, KeeperCompatibleInterface {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint basicChangesCounter;// every time we make a call to the keepers we increment this then use it to calculate the next uri of the nft.
    mapping(uint=>address) public tokenToUser;
    AggregatorV3Interface internal priceFeed;
    uint BTCPRice;

    //? keeper variables
    uint public immutable interval;
    uint public lastTimeStamp;

    //Fixed size arr for gas optimization
    string[3] bullUrisIpfs = [
        "https://ipfs.io/ipfs/Qmc3ueexsATjqwpSVJNxmdf2hStWuhSByHtHK5fyJ3R2xb?filename=simple_bull.json",
        "https://ipfs.io/ipfs/QmRsTqwTXXkV8rFAT4XsNPDkdZs5WxUx9E5KwFaVfYWjMv?filename=party_bull.json",
        "https://ipfs.io/ipfs/QmS1v9jRYvgikKQD6RrssSKiBTBH3szDK6wzRWF4QBvunR?filename=gamer_bull.json"
    ];

    string[3] bearUrisIpfs = [
        "https://ipfs.io/ipfs/QmZVfjuDiUfvxPM7qAvq8Umk3eHyVh7YTbFon973srwFMD?filename=simple_bear.json",
        "https://ipfs.io/ipfs/QmP2v34MVdoxLSFj1LbGW261fvLcoAsnJWHaBK238hWnHJ?filename=coolio_bear.json",
        "https://ipfs.io/ipfs/QmQMqVUHjCAxeFNE9eUxf89H1b7LpdzhvQZ8TXnj4FPuX1?filename=beanie_bear.json"
    ];

    constructor(uint256 _updateInterval) ERC721("BullBear", "BBS"){
        priceFeed = AggregatorV3Interface(0xECe365B379E1dD183B20fc5f022230C044d51404);
        interval = _updateInterval;
        lastTimeStamp = block.timestamp;
        BTCPRice = uint256(getLatestPrice());
    }

    function safeMint(address _to) public /**onlyOwner*/ {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        //store the owner of the NFT
        tokenToUser[tokenId]=msg.sender;
        // mint NFT
        _safeMint(_to, tokenId);
        // default to simple bull.json URI
        _setTokenURI(tokenId, bullUrisIpfs[0]);
    }

    function updateUriWhitCounter() public {
        uint256 index = basicChangesCounter % 3;//0,1,2
        basicChangesCounter++;

        uint256 newPrice = uint256(getLatestPrice());
        string memory uri;//new URI

        if (BTCPRice > newPrice) {
            uri = bullUrisIpfs[index];
        } 
        else if (BTCPRice < newPrice) {
            uri = bearUrisIpfs[index];
        }
        else {
            // stop the ejectution of the function to save gas
            return;
        }

        // Update btc price
        BTCPRice = newPrice;

        //update all the nft's
        uint256 currCounter = _tokenIdCounter.current();
        for (uint index; index < currCounter; index++) {
            _setTokenURI(index, uri);
        }
    }

    /*
    * Price Feed Function
    */
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


    /*
    * Upkeep functions
    */
    // this is the function that get's called once every new block is mined (off-chain)
    // just to check if the callback function should be called
    function checkUpkeep(bytes calldata /* checkData */) external view override returns (bool upkeepNeeded, bytes memory /* performData */) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
    }

    // callback function (on-chain)
    function performUpkeep(bytes calldata /* performData */) external override {
        require((block.timestamp - lastTimeStamp) > interval,"Second check for interval failed");
        lastTimeStamp = block.timestamp;
        updateUriWhitCounter();
    }

    /*
    * The following functions are overrides required by Solidity.
    */
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