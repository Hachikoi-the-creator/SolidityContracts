const hre = require("hardhat");

const main = async () => {
  try {
    const BULL_BEAR = await hre.ethers.getContractFactory("BullBear");
    const BullBear = await BULL_BEAR.deploy();
    await BullBear.deployed();

    console.log("Contract deployed to:", BullBear.address);
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
