const hre = require("hardhat");

const main = async () => {
  try {
    const PRICE_CONSUMER = await hre.ethers.getContractFactory("PriceConsumerV3");
    const PriceConsumer = await PRICE_CONSUMER.deploy();
    await PriceConsumer.deployed();

    console.log("Contract deployed to:", PriceConsumer.address);
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
