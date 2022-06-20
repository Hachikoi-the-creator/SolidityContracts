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
  solidity: "0.8.7",
  // ---------- RINKEBY 
  networks: {
    rinkeby: {
      url: process.env.RINKEBY_ALCHEMY_LINK,
      accounts: [process.env.METAMASK_PRIVATE_KEY],
    },
  },

  etherscan: {
    apiKey: {
      rinkeby: process.env.ETHERSCAN_API_KEY,
    },
  },
  // -------------- MUMBAI
  // networks: {
  //   mumbai: {
  //     url: process.env.MUMBAI_ALCHEMY_API_KEY,
  //     accounts: [process.env.METAMASK_PRIVATE_KEY],
  //   },
  // },

  // etherscan: {
  //   apiKey: {
  //     polygonMumbai: process.env.POLYGONSCAN_API_KEY,
  //   },
  // },
};

