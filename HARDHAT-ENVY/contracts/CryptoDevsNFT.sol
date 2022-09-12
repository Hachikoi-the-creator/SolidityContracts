// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

interface IWhitelist {
    // call the mapping getter from whitelist contract
    function whitelistedAddresses(address) external view returns (bool);
}

error PresalePeriodUnactive_ExpiredOrNotActivated();
error FailedToSendEther_CallError_WrongAmount();
error UserNotWhitelisted();
error CanOnlyMintOnce();
error ContractPaused();
error NoMoreNFTSupply();

contract CryptoDevsNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    // pause the contract in case of an emergency
    bool private _paused;

    Counters.Counter private _tokenIdCounter;

    IWhitelist private whitelistInterface;

    uint immutable nftsMintLimit;
    mapping(address => uint) s_addressToMint;

    bool public presaleStarted;
    uint public _presaleEndTimestamp;

    constructor(address _whitelistAddress, uint _nftLimit)
        ERC721("CryptoDevsNFT", "CD7")
    {
        nftsMintLimit = _nftLimit;
        whitelistInterface = IWhitelist(_whitelistAddress);
    }

    /*
     * Presale logic
     */
    function startPresale() public onlyOwner {
        if (!presaleStarted) presaleStarted = true;
        // Solidity has cool syntax for timestamps (seconds, minutes, hours, days, years)
        _presaleEndTimestamp = block.timestamp + 5 minutes;
    }

    /*
     * Mint funcs
     */
    /**
     * @dev presaleMint allows a user to mint for half the price
     */
    function presaleMint()
        public
        payable
        NotPaused
        mintingAllowed(_getNFTPrice(true))
    {
        if (!presaleStarted || block.timestamp > _presaleEndTimestamp) {
            revert PresalePeriodUnactive_ExpiredOrNotActivated();
        }
        if (!whitelistInterface.whitelistedAddresses(msg.sender)) {
            revert UserNotWhitelisted();
        }
        s_addressToMint[msg.sender]++;
        _tokenIdCounter.increment();
        //_safeMint is a safer version of the _mint function as it ensures that
        // if the address being minted to is a contract, then it knows how to deal with ERC721 tokens
        // If the address being minted to is not a contract, it works the same way as _mint
        _mintingLogic();
    }

    /**
     * @dev Minitn for when presale ended
     */
    function mint()
        public
        payable
        NotPaused
        mintingAllowed(_getNFTPrice(false))
    {
        if (s_addressToMint[msg.sender] != 0) {
            revert CanOnlyMintOnce();
        }

        s_addressToMint[msg.sender]++;
        _tokenIdCounter.increment();
        _mintingLogic();
    }

    /*
     *Modifiers
     */
    modifier NotPaused() {
        if (_paused) {
            revert ContractPaused();
        }
        _;
    }

    modifier mintingAllowed(uint _price) {
        if (_tokenIdCounter.current() >= nftsMintLimit) {
            revert NoMoreNFTSupply();
        } else if (msg.value != _price) {
            revert FailedToSendEther_CallError_WrongAmount();
        }
        _;
    }

    /*
     *Dev tools
     */
    function _getNFTPrice(bool presaleMint_) internal pure returns (uint) {
        if (presaleMint_) {
            return 0.05 ether;
        }
        return 0.1 ether;
    }

    /**@dev Repeated logic on presale & normal minting*/
    function _mintingLogic() internal {
        _safeMint(msg.sender, _tokenIdCounter.current());
        _setTokenURI(
            _tokenIdCounter.current(),
            "https://ipfs.filebase.io/ipfs/QmZrUAF7QKmC6SUixRVvDg5aTaBfYZXjWDT2R61ZkrKsJx"
        );
    }

    /**@dev withdraw sends all the ether to owner  */
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        if (!sent) {
            revert FailedToSendEther_CallError_WrongAmount();
        }
    }

    /**@dev emergency pause */
    function setPaused(bool val_) public onlyOwner {
        _paused = val_;
    }

    // Using the inteface
    function checkWhitelisted(address _user) public view returns (bool) {
        return whitelistInterface.whitelistedAddresses(_user);
    }

    // Default mint
    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        // hard codded URI
        _setTokenURI(
            tokenId,
            "https://ipfs.filebase.io/ipfs/QmZrUAF7QKmC6SUixRVvDg5aTaBfYZXjWDT2R61ZkrKsJx"
        );
    }

    /**@dev allows the contract to receive eth */
    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    /*
     * The following functions are overrides required by Solidity.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
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
