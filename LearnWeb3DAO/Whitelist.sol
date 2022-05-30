//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Whitelist {
    // Max number of whitelisted addresses allowed max:255
    uint8 public maxWhitelistedAddresses;

    // no more whitelist addresses if this is equal to `maxWhitelistedAddresses`
    uint8 public numAddressesWhitelisted;

    // Create a mapping of whitelistedAddresses
    // if an address is whitelisted, we would set it to true, it is false by default for all other addresses.
    mapping(address => bool) public whitelistedAddresses;

    // Setting the Max number of whitelisted addresses
    // Owner will put the value at the time of deployment
    constructor(uint8 _maxWhitelistedAddresses) {
        maxWhitelistedAddresses = _maxWhitelistedAddresses;
    }

    /*
     *@dev addAddressToWhitelist - This function adds the address of the sender to the whitelist
     */
    function addAddressToWhitelist() public {
        // check if the user has already been whitelisted
        require(
            !whitelistedAddresses[msg.sender],
            "Sender has already been whitelisted"
        );
        // check if the numAddressesWhitelisted < maxWhitelistedAddresses, if not then throw an error.
        require(
            numAddressesWhitelisted < maxWhitelistedAddresses,
            "Can't add more addresses, limit reached"
        );
        // Add the address which called the function to the whitelistedAddress array
        whitelistedAddresses[msg.sender] = true;
        // Increase the number of whitelisted addresses
        numAddressesWhitelisted += 1;
    }
}
