(async () => {
    try {
        const gameContractFactory = await hre.ethers.getContractFactory("MyEpicGame");
        const gameContract = await gameContractFactory.deploy(
            ["Michaelangelo", "Raphael", "Leonardo"],       // Names
            ["https://i.imgur.com/C6j1tZF.jpeg", // Images
                "https://i.imgur.com/Xapy2Cb.jpeg",
                "https://i.imgur.com/c8byM35.gif"],
            ["nunchucks", "sais", "swords"],
            [100, 200, 300],                    // HP values
            [100, 50, 25]                       // Attack damage values
        );
        await gameContract.deployed();
        console.log("Contract deployed to: ", gameContract.address);
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
})()