(async () => {
    try {
        const gameContractFactory = await hre.ethers.getContractFactory("StickmanBattleGame");
        const gameContract = await gameContractFactory.deploy(
            ["Red Shirt Hel", "Frosty Jack", "Blue Lee"],       // Names
            ["https://cloudflare-ipfs.com/ipfs/QmYTW85JiTf75Yw2QNvCJP2Hyakg6fNTsyyhFzCdJDM52P", // Images
                "https://cloudflare-ipfs.com/ipfs/QmdpwzcAZb4GanuEFMQgwX85FcCvh9X6aLHHaR2eFDHtAm",
                "https://cloudflare-ipfs.com/ipfs/QmVuxzD9Vawj5Tr9dJLcxTUYMvZcJYRZsX7yCS2RtYRdBk"],
            ["phaser", "katana", "staff"],
            [100, 200, 300],                    // HP values
            [100, 50, 25]                       // Attack damage values
        );
        await gameContract.deployed();
        console.log("Contract deployed to: ", gameContract.address);

        let txn;
        txn = await gameContract.mintCharacterNFT(0);
        await txn.wait;
        console.log("Minted NFT #1");

        txn = await gameContract.mintCharacterNFT(1);
        await txn.wait;
        console.log("Minted NFT #2");

        txn = await gameContract.mintCharacterNFT(2);
        await txn.wait;
        console.log("Minted NFT #3")
        ;
        txn = await gameContract.mintCharacterNFT(1);
        await txn.wait;
        console.log("Minted NFT #4");
        
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
})()