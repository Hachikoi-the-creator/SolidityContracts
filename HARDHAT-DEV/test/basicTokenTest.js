const { expect } = require("chai");

describe("BasicToken contract", () => {
  let BasicToken;
  let hardhatToken;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async () => {
    BasicToken = await ethers.getContractFactory("BasicToken");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    hardhatToken = await BasicToken.deploy(10000);
  });

  // You can nest describe calls to create subsections.
  describe("Deployment", () => {
    it("Should set the right owner", async () => {
      expect(await hardhatToken.owner()).to.equal(owner.address);
    });

    it("Should assign half total supply of tokens to the owner", async function () {
      const ownerBalance = await hardhatToken.balanceOf(owner.address);
      expect(await hardhatToken.totalSupply() / 2).to.equal(ownerBalance);
    });
  });

  describe("Transactions", () => {
    it("Should transfer tokens between accounts", async () => {
      // Transfer 50 tokens from owner to addr1
      await hardhatToken.transferTo(addr1.address, 50);
      const addr1Balance = await hardhatToken.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(50);

      // Transfer 50 tokens from addr1 to addr2
      // We use .connect(signer) to send a transaction from another account
      await hardhatToken.connect(addr1).transferTo(addr2.address, 50);
      const addr2Balance = await hardhatToken.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(50);
    });

    it("Should fail if sender doesn’t have enough tokens", async () => {
      const initialOwnerBalance = await hardhatToken.balanceOf(owner.address);

      // Try to send 1 token from addr1 (0 tokens) to owner (1000000 tokens).
      // `require` will evaluate false and revert the transaction.
      await expect(
        hardhatToken.connect(addr1).transferTo(owner.address, 1)
      ).to.be.revertedWith("Not enough tokens");

      // Owner balance shouldn't have changed.
      expect(await hardhatToken.balanceOf(owner.address)).to.equal(
        initialOwnerBalance
      );
    });

    it("Should update balances after transfers", async () => {
      const initialOwnerBalance = await hardhatToken.balanceOf(owner.address);

      // Transfer 100 tokens from owner to addr1.
      await hardhatToken.transferTo(addr1.address, 100);

      // Transfer another 50 tokens from owner to addr2.
      await hardhatToken.transferTo(addr2.address, 50);

      // Check balances.
      const finalOwnerBalance = await hardhatToken.balanceOf(owner.address);
      expect(finalOwnerBalance).to.equal(initialOwnerBalance.sub(150));

      const addr1Balance = await hardhatToken.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(100);

      const addr2Balance = await hardhatToken.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(50);
    });
  });
});

