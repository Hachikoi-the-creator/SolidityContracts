//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace is ERC721URIStorage {
    using Counters for Counters.Counter;

    address payable public owner;
    Counters.Counter private tokenIdCounter_;
    // A counter for all the transactions made
    Counters.Counter private itemSoldCounter_;

    uint public listingPrice = 0.01 ether;

    // When nft is listed for the first time
    struct ListedToken {
        uint price; //set by the seller
        uint tokenId;
        address owner; //same as seller on initialization
        address seller;
        bool currentlyListed; //? owo what is this?
    }

    // Make gettin NFT data easier
    mapping(uint => ListedToken) private idToListedToken;

    // Emits everytime an NFT is succesfully listed/added
    event TokenListedSuccesfully(
        uint indexed tokenId,
        uint price,
        address owner,
        address seller,
        bool currentlyListed
    );

    constructor() ERC721("HachiMarketplace", "8MK") {
        owner = payable(msg.sender);
    }

    /**
     * @dev Gives the user that calls this function an NFT
     * @param tokenURI The FE gives us the respective URI
     * @param price The price the user decided to give to it's NFT
     */
    function createToken(string memory tokenURI, uint256 price)
        public
        payable
        returns (uint)
    {
        tokenIdCounter_.increment();
        uint256 newTokenId = tokenIdCounter_.current();

        //Mint the NFT
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);

        //Helper function to update Global variables and emit an event
        createListedToken(newTokenId, price);

        return newTokenId;
    }

    /**
     * @dev Transfers the NFT from the creator to the contract) &&
     * @dev Updates all the data for the newly created NTF
     */
    function createListedToken(uint256 _tokenId, uint256 _price) private {
        //Make sure the sender sent enough ETH to pay for listing (comission for using the platform!)
        require(msg.value == listingPrice, "I don't get this");
        // Sanity check
        require(_price > 0, "Uh oh we cannot sell for negative prices~");

        idToListedToken[_tokenId] = ListedToken({
            price: _price,
            tokenId: _tokenId,
            owner: payable(address(this)),
            seller: payable(msg.sender),
            currentlyListed: true
        });

        _transfer(msg.sender, address(this), _tokenId);

        //Emit the event. The frontend parses this message and updates the end user
        emit TokenListedSuccesfully({
            price: _price,
            tokenId: _tokenId,
            owner: address(this),
            seller: msg.sender,
            currentlyListed: true
        });
    }

    /*
     *Fetch NFTs functions
     */
    /**
     * @dev useful for the FE, returns an array whit info of all the NFT's available for sale  */
    function getAllNFTs() public view returns (ListedToken[] memory) {
        uint nftCount = tokenIdCounter_.current();
        // ListedToken, weird sintax because is in memory and must be fixed size
        ListedToken[] memory allNfts = new ListedToken[](nftCount);

        // using an external counter to corretly filter the non-listed items, but not leaving empty spots in the array
        uint index;
        for (uint i = 0; i < nftCount; i++) {
            ListedToken storage currentItem = idToListedToken[index];
            allNfts[index] = currentItem;
            index++;
        }

        return allNfts;
    }

    /**
     *@dev Filters all NFTs to get only my NFTs
     */
    function getMyNFTs() public view returns (ListedToken[] memory) {
        uint totalNftCount = tokenIdCounter_.current();
        uint itemCount;
        uint currentIndex;

        // Get how many NFT's does X user have
        // needs to be done first because we return an array (fixed size)
        for (uint i = 1; i < totalNftCount + 1; i++) {
            // Check if X user is either the owner of the seller of the Nft
            if (
                idToListedToken[i].owner == msg.sender ||
                idToListedToken[i].seller == msg.sender
            ) {
                itemCount++;
            }
        }

        ListedToken[] memory userNfts = new ListedToken[](itemCount);
        for (uint i = 1; i < itemCount + 1; i++) {
            if (
                idToListedToken[i].owner == msg.sender ||
                idToListedToken[i].seller == msg.sender
            ) {
                ListedToken storage currentItem = idToListedToken[i];
                userNfts[currentIndex] = currentItem;
                currentIndex++;
            }
        }

        return userNfts;
    }

    /*
     * Selling & Buying process funcs
     */
    /**
     *@dev When the user buys an Nft whit enough ETH, the ownership transfernce is done and uint listingPrice is given to the seller */
    function executeSale(uint256 _tokenId) public payable {
        uint price = idToListedToken[_tokenId].price;
        address seller = idToListedToken[_tokenId].seller;

        require(
            msg.value == price,
            "Please send enough ETH to pay for this! hmph!"
        );

        // update NFT data
        idToListedToken[_tokenId].currentlyListed = true;
        idToListedToken[_tokenId].seller = payable(msg.sender);
        itemSoldCounter_.increment();

        // Transfer NFT (from contract to new Owner)
        _transfer(address(this), msg.sender, _tokenId);
        // weird approvation
        approve(address(this), _tokenId);

        //Transfer the listing fee to the marketplace creator
        payable(owner).transfer(listingPrice);
        //Transfer the proceeds from the sale to the seller of the NFT
        payable(seller).transfer(msg.value);
    }

    /*
     * Debugging functions
     */
    function updateListPrice(uint256 _listPrice) public payable {
        require(owner == msg.sender, "Only owner can update listing price");
        listingPrice = _listPrice;
    }

    function getLatestIdToListedToken()
        public
        view
        returns (ListedToken memory)
    {
        uint256 currentTokenId = tokenIdCounter_.current();
        return idToListedToken[currentTokenId];
    }

    function getListedTokenForId(uint256 tokenId)
        public
        view
        returns (ListedToken memory)
    {
        return idToListedToken[tokenId];
    }

    function getCurrentToken() public view returns (uint256) {
        return tokenIdCounter_.current();
    }
}
