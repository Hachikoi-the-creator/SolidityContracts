const { expect } = require("chai");
require("@nomicfoundation/hardhat-chai-matchers");
// const { mine } =require("@nomicfoundation/hardhat-network-helpers");
require("@nomicfoundation/hardhat-network-helpers");

describe("Combo BREAKER (rnd testing)", () => {
  let ContractFactory;
  let contractInstance;

  let owner;
  let addr1;
  let addr2;
  let addrArr;

  beforeEach(async () => {
    [owner, addr1, addr2, ...addrArr] = await ethers.getSigners();

    ContractFactory = await ethers.getContractFactory("TestingShit");
    contractInstance = await ContractFactory.deploy();
  });

  it("Triggers event whit correct values", async () => {
    // args declared withing the function
    await expect(contractInstance.triggerEvent())
      .to.emit(contractInstance, "MyEvent")
      .withArgs(13, 7);
  });

  it("Should warp time at will", async () => {
    console.log("Starting thing");
    // await ethers.provider.send("evm_increaseTime", [3600]);
    await network.provider.send("evm_increaseTime", [3600]);
    const endTime = await network.provider.send("evm_mine");
    console.log(endTime);
    // expect(Number(startTime)).to.be.below(Number(endTime));
    //
    //
    //
    // await mine(); //mine empty block
    // const start = await time.latest();
    // await time.increase(3600);
    // await mine(); //mine empty block
    // const end = await time.latest();
    // expect(start).to.be.below(end);
    //
    //
    //
    await network.provider.send("evm_increaseTime", [3600]);
    await expect(7).to.be(7);
  });
});
