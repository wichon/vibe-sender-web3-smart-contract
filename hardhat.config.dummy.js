require('@nomiclabs/hardhat-waffle');

module.exports = {
  solidity: '0.8.0',
  networks: {
    rinkeby: {
      url: '', // TODO: set here your Alchemy API url - https://www.alchemy.com/
      accounts: [''], // TODO: set here your private key from your Etherum (Rinkeby) wallet
    },
  },
};