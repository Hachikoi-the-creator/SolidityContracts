# Table of contents
- [Table of contents](#table-of-contents)
  - [Submit data](#submit-data)
  - [Deployments](#deployments)
- [Some notes](#some-notes)
- [Basic steps](#basic-steps)
- [Extra stuff](#extra-stuff)
- [Send ETH to contract](#send-eth-to-contract)
- [Send & receive ETH from/to user](#send--receive-eth-fromto-user)
  - [How to test it works?](#how-to-test-it-works)
  - [Extra challenges](#extra-challenges)


## Submit data

- email: vip.hd777@gmail.com
- Metamask adx: 0x9f83523C25aC79Be71ea16F303c38FA7b792A5e8

- repo: https://github.com/Hachikoi-the-creator/SolidityContracts/blob/main/RoadToWeb3/6-schalafold-eth/contracts/Staker.sol
- contract adx: 0xbd2FF7cD543334759b3eF2Fc57d63EfbED58e936

## Deployments
- (lil upgrade, Rinkeby) - 0xB3508810A8cF72d8F564C672f0c970396c0E211e
- (bigg upgrade, Rinkeby 169, 369 VERIFIED) - 0xbd2FF7cD543334759b3eF2Fc57d63EfbED58e936


# Some notes
- run React dev: `yarn dev`
- run hardhat localhost: `yarn chain`
- re-deploy contracts: `yarn deploy --reset`


# Basic steps
- For simplicity, we only expect a single user to interact with our staking dApp
- We need to be able to deposit and withdraw from the Staker Contract
    - Staking is a single-use action, meaning once we stake we cannot re-stake again
    - Withdraws from the contract removes the entire principal balance and any accrued interest
- The Staker contract has an interest payout rate of 0.1 ETH for every second that the deposited ETH is eligible for interest accrument
- Upon contract deployment,  the Staker contract should begin 2 timestamp counters. The first deadline should be set to 2 minutes and the second set to 4 minutes
    - The 2-minute deadline dictates the period in which the staking user is able to deposit funds. (Between t=0 minutes and t=2 minutes, the staking user can deposit)
    - All blocks that take place between the deposit of funds to the 2-minute deadline are valid for interest accrual
    - After the 2-minute withdrawal deadline has passed, the staking user is able to withdraw the entire principal balance and any accrued interest until the 4-minute deadline hits
    - After the additional 2-minute window for withdraws has passed, the user is blocked from withdrawing their funds since they timed out.
- If a staking user has funds left, we have one last function which we can call to "lock" the funds in an external contract that is already pre-installed in our Scaffold-Eth environment,  ExampleExternalContract.sol


# Extra stuff
- find a better way to set the timelines instead of using block.timestamp use...

# Send ETH to contract
**Sender**
```c#
function killStake() public claimDeadlineReached(true) notCompleted {
    uint contractBalance = address(this).balance;
    // that's how we send ETH to another contract
    exampleExternalContract.complete{value: contractBalance}();
}
```

**Receiver**
```c#
function complete() public payable {
    alreadyStaked = true;
}
```


# Send & receive ETH from/to user
**Receive**
```c#
function complete() public payable {
    // ETH goes directly to the contract's balance
}
```

**Send**
```c#
function sendETH() public {
    // transfer ETH, weird syntax but is the recommended method
    // Call returns a boolean value indicating success or failure.
    (bool sent, /*bytes memory data*/) = msg.sender.call{value: stakeRewards}("");
}
```


## How to test it works? 
- Get some ETH to the test account by copying the adx, then wallet icon in the bo'om left
    - same for the contract
- now you can keep calling the stake function until the reamining time runs out (2 min)
- once the stake period runs out, you can now retire your initial investemnt and winnings


## Extra challenges
1. Update the interest mechanism in the Staker.sol contract so that you receive a "non-linear" amount of ETH based on the blocks between deposit and withdrawal
2. Allow users to deposit any arbitrary amount of ETH into the smart contract, not just 0.5 ETH.
3. Instead of using the vanilla ExampleExternalContract contract, implement a function in Staker.sol that allows you to retrieve the ETH locked up in ExampleExternalContract and re-deposit it back into the Staker contract.
- Make sure to only "white-list" a single address to call this new function to gate its usage!
- Make sure that you create logic/remove existing code to ensure that users are able to interact with the Staker contract over and over again! We want to be able to ping-pong from Staker -> ExampleExternalContract repeatedly!