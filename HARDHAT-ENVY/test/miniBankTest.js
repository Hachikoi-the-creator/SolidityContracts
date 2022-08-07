const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MiniBank contract", () => {
  let miniBankFactory, miniBankContract, owner, user1, user2, user3;

  beforeEach(async () => {
    miniBankFactory = await ethers.getContractFactory("MiniBank");
    [owner, user1, user2, user3] = await ethers.getSigners();
    miniBankContract = await miniBankFactory.deploy();
    await miniBankContract.deployed();
  });

  it("Should return the number of opened accounts", async () => {
    expect(await miniBankContract.accountsOpened()).to.equal(0);
  });

  it("Should allow multiple users to open accounts", async () => {
    await miniBankContract.connect(user1).openAccount();
    await miniBankContract.connect(user2).openAccount();
    await miniBankContract.connect(user3).openAccount();
    expect(await miniBankContract.accountsOpened()).to.equal(3);
  });

  it("Should prevent users to open a second account", async () => {
    await miniBankContract.connect(user1).openAccount();
    await expect(
      miniBankContract.connect(user1).openAccount()
    ).to.be.revertedWith("MiniBank: User has an account already!");
  });

  it("Should allow users to deposit ETH", async () => {
    await miniBankContract.connect(user1).openAccount();
    await miniBankContract.connect(user1).deposit({ value: 1 });
    expect(await miniBankContract.connect(user1).checkBalance()).to.equal(1);
  });
});
