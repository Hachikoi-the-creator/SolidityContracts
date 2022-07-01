const hre = require("hardhat");

const main = async () => {
  try {
    const CONTRACT = await hre.ethers.getContractFactory("NFTMarketplace");
    const Contract = await CONTRACT.deploy();//constructor args
    await Contract.deployed();

    console.log("Contract deployed to:", Contract.address);
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
