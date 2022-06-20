// SPDX-License-Identifier: MIT
pragma solidity ^0.8.x;

contract CheckTimestamp {
    uint256 public modDepositDeadline;
    uint256 public modClaimDeadline;

    uint256 public depositDeadline;
    uint256 public claimDeadline;

    constructor(uint256 _depositTimeLimit, uint256 _claimTimeLimit) {
        modDepositDeadline = block.timestamp + _depositTimeLimit;
        modClaimDeadline = block.timestamp + _claimTimeLimit;


        depositDeadline = block.timestamp;
        claimDeadline = block.timestamp;
	}

    function checkTimes() public view returns(uint, uint) {
        return (modClaimDeadline, modDepositDeadline);
    }

    function checkDeposit() public view returns(bool) {
        return modDepositDeadline == depositDeadline;
    }

    function checkClaim() public view returns(bool) {
        return modClaimDeadline == claimDeadline;
    }
}