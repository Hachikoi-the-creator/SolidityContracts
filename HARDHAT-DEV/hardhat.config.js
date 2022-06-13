require("dotenv").config();
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
// task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
//   const accounts = await hre.ethers.getSigners();

//   for (const account of accounts) {
//     console.log(account.address);
//   }
// });


module.exports = {
  solidity: "0.8.8",

  networks: {
    mumbai: {
      url: process.env.ALCHEMY_API_KEY,
      accounts: [process.env.MUMBAI_PRIVATE_KEY],
    },
  },

  etherscan: {
    apiKey: {
      polygonMumbai: process.env.POLYGONSCAN_API_KEY,
    },
  },
};

