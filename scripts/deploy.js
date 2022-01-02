  const main = async () => {
    const vibeSenderContractFactory = await hre.ethers.getContractFactory('VibeSender');
    const vibeSenderContract = await vibeSenderContractFactory.deploy({
      value: hre.ethers.utils.parseEther('0.1'),
    });
  
    await vibeSenderContract.deployed();
  
    console.log('VibeSender Contract address: ', vibeSenderContract.address);
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.error(error);
      process.exit(1);
    }
  };
  
  runMain();