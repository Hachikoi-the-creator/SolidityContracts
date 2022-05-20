// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BuyMeCoffee {
    // Event to emit wwhen memo is created
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // List of all memos recived from friends
    Memo[] memos;

    // addres of the contract deployer
    address payable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    /*
     * @dev Buys a coffe con the contract owner
     * @param _name, the name of the coffe buyer
     * @param _message, message from the coffe buyer
     */
    function buyCoffee(string memory _name, string memory _message)
        public
        payable
    {
        require(msg.value > 0, "Please send some money U.U");
        // Add new memo to the array
        memos.push(Memo(msg.sender, block.timestamp, _name, _message));

        // Emit a log event when a memo is created
        emit NewMemo(msg.sender, block.timestamp, _name, _message);
    }

    /*
     * @dev withdraws the contact balance to the contract deployer
     */
    function withdrawTips() public {
        // address(this).balance; - Here's where all the money is stored
        require(owner.send(address(this).balance)); // ???
    }

    /*
     * @dev Retrieve all the memos stored in the contract
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }
}
