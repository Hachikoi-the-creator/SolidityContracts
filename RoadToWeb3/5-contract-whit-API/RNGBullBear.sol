// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";

// import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";
// import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
// import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

// import "hardhat/console.sol";

//!Once the contract is deployed, don't forget to add it to your VRF as a new consumer

contract BullBear is ERC721, ERC721Enumerable, ERC721URIStorage, KeeperCompatibleInterface, Ownable, VRFConsumerBaseV2  {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    AggregatorV3Interface public pricefeed;

    // VRF
    VRFCoordinatorV2Interface public COORDINATOR;
    uint256[] public s_randomWords;
    uint256 public s_requestId;
    uint32 public callbackGasLimit = 500000; // set higher as fulfillRandomWords is doing a LOT of heavy lifting.
    uint64 s_subscriptionId; // private.
    bytes32 keyhash =  0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc; // keyhash, see for Rinkeby https://docs.chain.link/docs/vrf-contracts/#rinkeby-testnet
    
    /**
    * Use an interval in seconds and a timestamp to slow execution of Upkeep
    */
    uint public /* immutable */ interval; 
    uint public lastTimeStamp;
    int256 public currentPrice;

    enum MarketTrend{BULL, BEAR} // Create Enum
    MarketTrend public currentMarketTrend = MarketTrend.BULL; 
    
    //Fixed size arr for gas optimization
    // These still work somehow, and my filebase was acting weird.
    string[3] bullUrisIpfs = [
        "https://ipfs.io/ipfs/QmdcURmN1kEEtKgnbkVJJ8hrmsSWHpZvLkRgsKKoiWvW9g?filename=simple_bull.json",
        "https://ipfs.io/ipfs/QmRJVFeMrtYS2CUVUM2cHJpBV5aX2xurpnsfZxLTTQbiD3?filename=party_bull.json",
        "https://ipfs.io/ipfs/QmRXyfi3oNZCubDxiVFre3kLZ8XeGt6pQsnAQRZ7akhSNs?filename=gamer_bull.json"
    ];

    string[3] bearUrisIpfs = [
        "https://ipfs.io/ipfs/QmbKhBXVWmwrYsTPFYfroR2N7NAekAMxHUVg2CWks7i9qj?filename=simple_bear.json",
        "https://ipfs.io/ipfs/QmTVLyTSuiKGUEmb88BgXG3qNC8YgpHZiFbjHrXKH3QHEu?filename=coolio_bear.json",
        "https://ipfs.io/ipfs/Qmdx9Hx7FCDZGExyjLR6vYcnutUR8KhBZBnZfAPHiUommN?filename=beanie_bear.json"
    ];

    event TokensUpdated(string marketTrend);

    /* 
    BTC/USD Price Feed Contract Address on Rinkeby: 0xECe365B379E1dD183B20fc5f022230C044d51404
    Setup VRF. Rinkeby VRF Coordinator 0x6168499c0cFfCaCD319c818142124B7A15E857ab
    */
    constructor(uint updateInterval, address _pricefeed, address _vrfCoordinator, uint64 _subscriptionId)
        ERC721("Bull&Bear", "BBTK") VRFConsumerBaseV2(_vrfCoordinator) {

        interval = updateInterval; 
        lastTimeStamp = block.timestamp;  

        pricefeed = AggregatorV3Interface(_pricefeed);
        
        currentPrice = getLatestPrice();
        COORDINATOR = VRFCoordinatorV2Interface(_vrfCoordinator);

        setSubscriptionId(_subscriptionId);
    }


    function safeMint(address to) public  {
        uint256 tokenId = _tokenIdCounter.current();

        // Update the counter
        _tokenIdCounter.increment();

        _safeMint(to, tokenId);

        // Default to normal bull NFT 
        string memory defaultUri = bullUrisIpfs[0];
        _setTokenURI(tokenId, defaultUri);

        //console.log("DONE!!! minted token ", tokenId, " and assigned token url: ", defaultUri);
    }


    function checkUpkeep(bytes calldata /* checkData */) external view override returns (bool upkeepNeeded, bytes memory /*performData */) {
         upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
    }


    // Modified to handle VRF.
    function performUpkeep(bytes calldata /* performData */ ) external override {
        //We highly recommend revalidating the upkeep in the performUpkeep function
        if ((block.timestamp - lastTimeStamp) > interval ) {
            lastTimeStamp = block.timestamp;//update lastTimestamp
            int latestPrice =  getLatestPrice();
        
            if (latestPrice == currentPrice) {
                //console.log("NO CHANGE -> returning!");
                return;
            }

            if (latestPrice < currentPrice) {
                // bear
                currentMarketTrend = MarketTrend.BEAR;
            } else {
                // bull
                currentMarketTrend = MarketTrend.BULL;
            }

            // Initiate the VRF calls to get a random number (word)
            // that will then be used to to choose one of the URIs 
            // that gets applied to all minted tokens.
            requestRandomnessForNFTUris();
            // update currentPrice
            currentPrice = latestPrice;
        } else {
            //This should never trigger since we did the check in `checkUpkeep()`
            return;
        }
    }


    function getLatestPrice() public view returns (int256) {
         (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = pricefeed.latestRoundData();

        return price; //  example price returned 3034715771688
    }


    function requestRandomnessForNFTUris() internal {
        require(s_subscriptionId != 0, "Subscription ID not set"); 

        // Will revert if subscription is not set and funded.
        s_requestId = COORDINATOR.requestRandomWords(
            keyhash,
            s_subscriptionId, // See https://vrf.chain.link/
            3, //blocks mined for confirmation
            callbackGasLimit,
            1 // `numWords` we can work whit only one since we want an index
        );

        //console.log("Request ID: ", s_requestId);

    }


    // This is the callback that the VRF coordinator sends the 
    // random values to.
    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory randomWords
    ) internal override {
        s_randomWords = randomWords;//both are arrays 
        //console.log("...Fulfilling random Words");
        
        // we assumme we have the same number of URI in both arrays 
        //since the array works whit uint256 we need to cast it
        uint8 idx = uint8(s_randomWords[0] % bearUrisIpfs.length);

        //check performs the URI change in all the NFT's after checking for `currentMarketTrend`
        _updateAllTokenUris(idx);


        string memory trend = currentMarketTrend == MarketTrend.BULL ? "bullish" : "bearish";
        emit TokensUpdated(trend);
    }


    function setPriceFeed(address newFeed) public onlyOwner {
        pricefeed = AggregatorV3Interface(newFeed);
    }


    function setInterval(uint256 _newInterval) public onlyOwner {
        interval = _newInterval;
    }


    // For VRF Subscription Manager
    function setSubscriptionId(uint64 _id) public onlyOwner {
        s_subscriptionId = _id;
    }


    function setSubscriptionGasLimit(uint32 maxGas) public onlyOwner {
        callbackGasLimit = maxGas;
    }


    function setVrfCoodinator(address _address) public onlyOwner {
        COORDINATOR = VRFCoordinatorV2Interface(_address);
    }
    

    /***
    * Helpers
    ***/
    function _updateAllTokenUris(uint8 _rndIndex) internal {
        if (currentMarketTrend == MarketTrend.BULL) {
            for (uint i = 0; i < _tokenIdCounter.current() ; i++) {
                _setTokenURI(i, bullUrisIpfs[_rndIndex]);
            } 
        }
        else {
            for (uint i = 0; i < _tokenIdCounter.current() ; i++) {
                _setTokenURI(i, bearUrisIpfs[_rndIndex]);
            } 
        }
    }


    /***
    * The following functions are overrides required by Solidity.
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