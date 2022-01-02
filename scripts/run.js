(async () => {
    try {
        const gameContractFactory = await hre.ethers.getContractFactory("MyEpicGame");
        const gameContract = await gameContractFactory.deploy();
        await gameContract.deployed();
        console.log("Contract deployed to: ", gameContract.address);
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
})()