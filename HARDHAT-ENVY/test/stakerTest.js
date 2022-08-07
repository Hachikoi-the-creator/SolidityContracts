const { expect } = require("chai");

describe("BasicToken contract", () => {
  let hardhatStaker;
  let owner;
  let addr1;

  beforeEach(async () => {
    // Get the ContractFactory and Signers here.
    const Staker = await ethers.getContractFactory("Staker");
    [owner, addr1] = await ethers.getSigners();

    hardhatStaker = await Staker.deploy();
  });

  // Basic deployment testing
  describe("Deployment", () => {
    it("Should set the right owner", async () => {
      expect(await hardhatStaker.owner()).to.equal(owner.address);
    });

    it("The balance of the contract should be 0", async () => {
      expect(await hardhatStaker.balanceOf(hardhatStaker.address)).to.equal(0);
    });

  });
});