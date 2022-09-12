const hre = require("hardhat");

const main = async () => {
  const contractName = "CryptoDevsNFT";
  // const contractName = "Whitelist";

  try {
    const CONTRACT = await hre.ethers.getContractFactory(contractName);
    const Contract = await CONTRACT.deploy(
      "0xF70547378ac7d81E4009fFb5C18601F29CeADa06",
      "21"
    );
    // const Contract = await CONTRACT.deploy(10); //constructor args
    await Contract.deployed();

    console.log(`Contract ${contractName} deployed to:`, Contract.address);
  } catch (error) {
    console.log(error);
  }
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
