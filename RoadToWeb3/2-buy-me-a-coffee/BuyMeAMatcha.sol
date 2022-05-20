//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

//0xafbab0c25c2ca358081052532f7a3f1ecd4cff28
// Deployed to Goerli at 0xa8b260684d8B4B326236B06be222A4C64F76414e

//import "hardhat/console.sol";

contract BuyMeAMatcha {
    // Event to emit when a Memo is created
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    // Memo struct.
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // List of all memos received from friends
    Memo[] memos;

    // Address of contract deployer
    address payable public owner;

    // Deploy logic
    constructor() {
        // set to whoever deployed the address (only the owner can withdraw)
        //? challenge 1: create a function to allow owner address to be updated only by specific people
        owner = payable(msg.sender);
    }

    /**
     * @dev buy a matcha for contract owner
     * @param _name name of matcha buyer
     * @param _message a nice message from the matcha buyer
     */
    function buyMatcha(string memory _name, string memory _message)
        public
        payable
    {
        require(msg.value > 0, "can't buy matcha with 0 eth");

        // Adds the memo to storage
        memos.push(Memo(msg.sender, block.timestamp, _name, _message));

        // Emit a log event when a new memo is created
        emit NewMemo(msg.sender, block.timestamp, _name, _message);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() public {
        require(payable(msg.sender) == owner, "You are not the owner!");
        owner.transfer(address(this).balance); //challenge solved 1.1
    }

    /**
     * @dev retrieve all the memos received and stored on the blockchain
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

    /**@dev Allow Owner to change the owner variable
     * @param _newOwner new addres to withdrawMoneyTo
     */
    function changeOwner(address _newOwner) public {
        //challenge solved 1.2
        owner = payable(_newOwner);
    }

    /**@dev See the current owner*/
    function getOwner() public view returns (address) {
        return owner;
    }
}
