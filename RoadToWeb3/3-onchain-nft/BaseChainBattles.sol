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
    // Link an uint256, the NFTId, to another uint256, the level of the NFT.
    mapping(uint256 => uint256) public tokenIdToLevel;

    constructor() ERC721("ChainBattles", "CBTS") {}

    function generateCharacter(uint256 tokenId) public view returns (string memory) {
        //? annoying way to wrork whit json in Solidity unu
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
            '</svg>'
        );

        //? Convert the svg to Base64 code/text
        return string(abi.encodePacked("data:image/svg+xml;base64,",Base64.encode(svg)));
    }


    /**
     * @dev Get the level info
     * @param tokenId keep track of the users by id's
     */
    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevel[tokenId];
        //? int256 -> String tnx to 'using Strings for uint256;'
        return levels.toString();
    }


    /**
     * @dev
     * @param tokenID keep track of the users by id's
     */
    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        // ? this is how solidity works whit JSON objects 💢
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',tokenId.toString(),'",',
            '"description": "Battles on chain",',
            '"image": "',generateCharacter(tokenId),'"',
            "}"
        );

        return string(abi.encodePacked(
            "data:application/json;base64,",Base64.encode(dataURI)
            ));
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
