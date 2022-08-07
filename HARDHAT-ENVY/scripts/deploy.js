const hre = require("hardhat");

const main = async () => {
  // const contractName = "Whitelist";
  const contractName = "CryptoDevsNFT";
  try {
    const CONTRACT = await hre.ethers.getContractFactory(contractName);
    const Contract = await CONTRACT.deploy(
      "0xF70547378ac7d81E4009fFb5C18601F29CeADa06",
      "77"
    ); //constructor args
    await Contract.deployed();

    console.log(`Contract ${contractName} deployed to:`, Contract.address);
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
