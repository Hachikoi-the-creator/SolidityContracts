// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract ExampleExternalContract {

  bool public alreadyStaked;

  function complete() public payable {
    alreadyStaked = true;
  }

  function completed() public view returns(bool isCompleted) {
    return alreadyStaked;
  }
}
