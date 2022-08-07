const { expect } = require("chai");

describe("Whitelist NFT & Whitelist", () => {
  let WhitelistFactory;
  let WListContract;

  let CryptoFactory;
  let CD7Contract;

  let owner;
  let addr1;
  let addr2;
  let addArr;

  beforeEach(async () => {
    [owner, addr1, addr2, ...addArr] = await ethers.getSigners();

    WhitelistFactory = await ethers.getContractFactory("Whitelist");
    CryptoFactory = await ethers.getContractFactory("CryptoDevsNFT");

    //whitelist limit
    WListContract = await WhitelistFactory.deploy(3);
    // adx, nfts limit
    CD7Contract = await CryptoFactory.deploy(WListContract.address, 3);
  });

  /**
   * @div WHITELIST contract testing
   */
  // --------- Whitelisting depoyment
  describe("Whitelist Contract", () => {
    it("Should successfully whitelist 3 & fail at 4th", async () => {
      // add owner
      await WListContract.connect(owner).addAddressToWhitelist();
      expect(await WListContract.numAddressesWhitelisted()).to.equal(1);

      // add addr1
      await WListContract.connect(addr1).addAddressToWhitelist();
      expect(await WListContract.numAddressesWhitelisted()).to.equal(2);

      // add addr3
      await WListContract.connect(addr2).addAddressToWhitelist();
      expect(await WListContract.numAddressesWhitelisted()).to.equal(3);

      // fail add addr4
      await expect(
        WListContract.connect(adxArr[0]).addAddressToWhitelist()
      ).to.be.revertedWith("UnableToWithelist_SpotsFilled");
    });

    it("Should whitelist owner only once", async () => {
      // add owner
      WListContract.connect(owner);
      await WListContract.addAddressToWhitelist();
      expect(await WListContract.numAddressesWhitelisted()).to.equal(1);

      // add owner again (custom error :3)
      WListContract.connect(owner);
      await expect(WListContract.addAddressToWhitelist()).to.be.revertedWith(
        "UserAlreadyWhitelisted"
      );
    });
  });

  /**
   * @div NFT contract testing
   */
  // --------- NFT Deployment
  describe("NFT Contract", () => {
    it("Should set the right owner", async () => {
      // ERC721 adds owner func
      expect(await CD7Contract.owner()).to.equal(owner.address);
    });

    it("Should call external contract", async () => {
      expect(
        await CD7Contract.checkWhitelistedAddress(owner.address)
      ).to.be.equal(false);
    });

    it("Should be able to keep up whit external updates", async () => {
      // add owner
      await WListContract.connect(owner);
      await WListContract.addAddressToWhitelist();
      expect(await WListContract.numAddressesWhitelisted()).to.equal(1);

      expect(
        await CD7Contract.checkWhitelistedAddress(owner.address)
      ).to.be.equal(true);
    });

    // ------ presale
    it("Should allow presale-mint AFTER presale started", async () => {
      // check presale state change
      expect(await CD7Contract.presaleStarted()).to.be.equal(false);
      await CD7Contract.connect(owner).startPresale();
      expect(await CD7Contract.presaleStarted()).to.be.equal(true);

      //Mint on time
      expect(CD7Contract.balanceOf(owner)).to.be.equal(0);
      await CD7Contract.connect(owner).presaleMint();
      expect(CD7Contract.balanceOf(owner)).to.be.equal(1);

      // Warp time and fail mint
      await network.provider.send("evm_increaseTime", [3600]);
      await expect(
        CD7Contract.connect(owner).presaleMint()
      ).to.be.revertedWithCustomError("Presale_period_not_active");
    });
  });
});
