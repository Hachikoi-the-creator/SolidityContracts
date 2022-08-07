require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
// const fs = require("fs");
// const infuraId = fs.readFileSync(".infuraid").toString().trim() || "";
// task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
//   const accounts = await hre.ethers.getSigners();

//   for (const account of accounts) {
//     console.log(account.address);
//   }
// });
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 1337,
    },
    goerli: {
      url: process.env.GOERLY_ALCHEMY_LINK,
      accounts: [process.env.METAMASK_PRIVATE_KEY],
    },
    mumbai: {
      url: process.env.MUMBAI_ALCHEMY_LINK,
      accounts: [process.env.METAMASK_PRIVATE_KEY],
    },
    optimism: {
      url: process.env.OPTIMISM_KOVAN_ALCHEMY_LINK,
      accounts: [process.env.METAMASK_PRIVATE_KEY],
    },
  },

  etherscan: {
    apiKey: {
      polygonMumbai: process.env.POLYGONSCAN_API_KEY,
      goerli: process.env.ETHERSCAN_API_KEY,
      optimisticKovan: process.env.OPTIMISTICSCAN_API_KEY,
      ropsten: process.env.ETHERSCAN_API_KEY,
      kovan: process.env.ETHERSCAN_API_KEY,
      // avalancheFujiTestnet: process.env.
    },
  },

  solidity: {
    version: "0.8.7",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
