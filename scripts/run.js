const main = async () => {
    const [owner, john, alice, luis] = await hre.ethers.getSigners();
    const vibeSenderContractFactory = await hre.ethers.getContractFactory('VibeSender');
    const vibeSenderContract = await vibeSenderContractFactory.deploy({value: hre.ethers.utils.parseEther('0.1'),});
    await vibeSenderContract.deployed();
  
    console.log('Contract deployed to:', vibeSenderContract.address);
    console.log('Contract deployed by:', owner.address);

    /*
    * Get Contract balance
    */
    let contractBalance = await hre.ethers.provider.getBalance(
      vibeSenderContract.address
    );
    console.log('Contract balance:', hre.ethers.utils.formatEther(contractBalance));
  
    let vibeTxn = await vibeSenderContract.sendVibe("Hi! 🙂", true);
    await vibeTxn.wait();
  
    vibeTxn = await vibeSenderContract.connect(john).sendVibe("Die!", false);
    await vibeTxn.wait()
    vibeTxn = await vibeSenderContract.connect(john).sendVibe("Die!!", false);
    await vibeTxn.wait()
    vibeTxn = await vibeSenderContract.connect(john).sendVibe("Mother fucker Die!", false);
    await vibeTxn.wait()

    waveTxn = await vibeSenderContract.connect(alice).sendVibe("Hello!", true);
    await waveTxn.wait();
  
    ownerVibeScore = await vibeSenderContract.getMyVibeScore();
    console.log("Owner vibe score:", ownerVibeScore);
    johnVibeScore = await vibeSenderContract.connect(john).getMyVibeScore();
    console.log("John vibe score:", johnVibeScore);
    aliceVibeScore = await vibeSenderContract.connect(alice).getMyVibeScore();
    console.log("Alice vibe score:", aliceVibeScore);
    luisVibeScore = await vibeSenderContract.connect(luis).getMyVibeScore();
    console.log("Luis vibe score:", luisVibeScore);

    let allVibes = await vibeSenderContract.getAllVibes();
    console.log(allVibes);

    await vibeSenderContract.connect(john).getMyVibesCount()
    await vibeSenderContract.connect(john).getMyVibesCountByType(true)
    await vibeSenderContract.connect(john).getMyVibesCountByType(false)

    await vibeSenderContract.getTotalVibes();
    await vibeSenderContract.getTotalVibesByType(true);
    await vibeSenderContract.getTotalVibesByType(false);

    /*
    * Get Contract balance
    */
    contractBalance = await hre.ethers.provider.getBalance(
      vibeSenderContract.address
    );
    console.log('Contract balance:', hre.ethers.utils.formatEther(contractBalance));
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();