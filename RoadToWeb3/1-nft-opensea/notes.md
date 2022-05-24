# Table of contents
- [Table of contents](#table-of-contents)
  - [Final Result](#final-result)
  - [General Process](#general-process)

## Final Result
Contract Address: 0x37c564cf66128C01f2fD05B2ce3611Fca4ee89D1
OpenSea nft: https://testnets.opensea.io/assets/0x37c564cf66128c01f2fd05b2ce3611fca4ee89d1


## General Process
1. Generate an ERC721 template from [Contract Wizzard](https://docs.openzeppelin.com/contracts/4.x/wizard)
2. Open the contract in Remix or VSCode and make wanted changes (remove the onlyOwner, add MAX_SUPPLY & add a required statement)
3. Create an Alchemy acc and app
4. Add Alchemy network to metamask (whit view key -> HTTP)
5. Get som test ETH  and deploy the contract to Alchemy network
6. upload every NFT filebase & copy the link to the json file (metadata)
7. upload the metadata to filebase as well and copy that link to the safeMint function of the contract
8. wait up to 9hrs to see the matadata in open sea!