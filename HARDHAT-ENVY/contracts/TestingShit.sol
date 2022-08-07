// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract TestingShit {
    event MyEvent(uint num, uint pasta);

    function triggerEvent() public {
        emit MyEvent(13, 7);
    }

    function rndCall() public pure {
        uint asMe = 1 + 9;
    }
}
