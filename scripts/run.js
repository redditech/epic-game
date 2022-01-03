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
            [100, 50, 25],                       // Attack damage values
            "Shady Moe", // Boss name
            "https://cloudflare-ipfs.com/ipfs/QmVPxkugpFHXGuWpiUa3f8JY1sThht3A61J1aGWCkdbScZ", // Boss image
            "hook and claws", // boss weapon
            10000, // Boss hp
            50 // Boss attack damage
        );
        await gameContract.deployed();
        console.log("Contract deployed to: ", gameContract.address);

        let txn;
        // We only have three characters,
        // an NFT w/the character at index 2 of our array
        txn = await gameContract.mintCharacterNFT(2);
        await txn.wait;

        txn = await gameContract.attackBoss();
        await txn.wait;

        txn = await gameContract.attackBoss();
        await txn.wait;

        // Get the value of the NFT's URI
        let returnedTokenUri = await gameContract.tokenURI(1);
        console.log("Token URI:", returnedTokenUri);
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
})()