const hre = require("hardhat");

const main = async () => {
  try {
    const STAKER = await hre.ethers.getContractFactory("Staker");
    const Staker = await STAKER.deploy();//constructor args
    await Staker.deployed();

    console.log("Contract deployed to:", Staker.address);
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
