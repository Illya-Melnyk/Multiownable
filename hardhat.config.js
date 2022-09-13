require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
const ALCHEMY_API_KEY = "AuzLFYkeR9WXjFJI23v528EFP36s2zdt";

const GOERLI_PRIVATE_KEY = "2099c23c3a5831233246636bcfddf7ab34da7465374074fe38777132f3b461cd";


module.exports = {
  defaultNetwork: "goerli",
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY]
    }
  }
};
