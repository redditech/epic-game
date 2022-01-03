// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

// NFT contract to inherit from
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "base64-sol/base64.sol";

// Helper functions OpenZeppelin provides
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

// Let contract inherit from ERC721 - the standard NFT contract
contract StickmanBattleGame is ERC721 {
    struct CharacterAttributes {
        uint256 characterIndex;
        string name;
        string imageURI;
        string weapon;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    // The tokenId is the NFT's unique identifier, it's justa number that goes
    // 0, 1, 2, 3 etc
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // An array to help hold default data for all characters
    // Helpful when we mint new characters
    // to know their HP, AD, etc.
    CharacterAttributes[] defaultCharacters;

    // Create a mapping from the nft's tokenId => the NFT attributes
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

    // Create a mapping from an address => the NFT's tokenId.
    // This is an easy way to store the owner of the NFT and reference it later
    mapping(address => uint256) public nftHolders;

    struct BigBoss {
        string name;
        string imageURI;
        string weapon;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    BigBoss public bigBoss;

    // Data passed into the contract when it's first created initializing the characters.
    // We're going to actually pass these values in from run.js

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        string[] memory characterWeapons,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDmg,
        string memory bossName,
        string memory bossImageURI,
        string memory bossWeapon,
        uint bossHp,
        uint bossAttackDamage
        // Below this, the name and symbol for our tokenURI(tokenId);
    )
        ERC721("StickmanBattleGame", "SMBG")
    {

        bigBoss = BigBoss({
            name: bossName,
            imageURI: bossImageURI,
            weapon: bossWeapon,
            hp: bossHp,
            maxHp: bossHp,
            attackDamage: bossAttackDamage
        });
        console.log("Done initializing boss %s w/HP %s, img %s", bigBoss.name, bigBoss.hp, bigBoss.imageURI);
        console.log("%s is armed with: %s", bigBoss.name, bigBoss.weapon);

        // Loop through all the characters and save their values in our contract
        // so that we can use them later when we mint our NFTs.
        for (uint256 i = 0; i < characterNames.length; i += 1) {
            defaultCharacters.push(
                CharacterAttributes({
                    characterIndex: i,
                    name: characterNames[i],
                    imageURI: characterImageURIs[i],
                    weapon: characterWeapons[i],
                    hp: characterHp[i],
                    maxHp: characterHp[i],
                    attackDamage: characterAttackDmg[i]
                })
            );

            CharacterAttributes memory c = defaultCharacters[i];
            console.log(
                "Done initializing %s with w/HP %s, img %s",
                c.name,
                c.hp,
                c.imageURI
            );
            console.log("%s is armed with weapon: %s", c.name, c.weapon);
        }

        // increment tokenIds here so that the first NFT has an ID of 1.
        _tokenIds.increment();
    }

    function attackBoss() public {
        // Get the state of the player's NFT.
        uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
        CharacterAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
        console.log("\nPlayer w/character %s about to attack. Has %s HP and %s AD", player.name, player.hp, player.attackDamage);
        console.log("Boss %s has %s HP and %s AD", bigBoss.name, bigBoss.hp, bigBoss.attackDamage);
        
        // Make sure the player has more than 0 HP.
        require(
            player.hp > 0,
            "Error: character must have HP to attack boss."
        );

        // Make sure the boss has more than 0 HP.
        require(
            bigBoss.hp >0,
            "Error: boss must have HP to attack boss."
        );

        // Allow the player to attack the boss
        if (bigBoss.hp < player.attackDamage) {
            bigBoss.hp = 0;
        } else {
            bigBoss.hp = bigBoss.hp - player.attackDamage;
        }
        // Allow the boss to attack player
        if (player.hp < bigBoss.attackDamage) {
            player.hp = 0;
        } else {
            player.hp = player.hp - bigBoss.attackDamage;
        }

        // Console the outcome
        console.log("Player attacked boss with %s. New boss hp: %s", player.weapon, bigBoss.hp);
        console.log("Boss attacked player with %s. New player hp: %s\n", bigBoss.weapon, player.hp);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        CharacterAttributes memory charAttributes = nftHolderAttributes[
            _tokenId
        ];
        string memory weapon = charAttributes.weapon;
        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strMaxHp = Strings.toString(charAttributes.maxHp);
        string memory strAttackDamage = Strings.toString(
            charAttributes.attackDamage
        );

        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                charAttributes.name,
                " -- NFT #: ",
                Strings.toString(_tokenId),
                '", "description": "This is an NFT that lets people play in the game Stickman Battles!", "image": "',
                charAttributes.imageURI,
                '", "attributes": [ { "trait_type": "Preferred Weapon", "value" : "',
                weapon,'"',
                '}, {"trait_type": "Health Points", "value" :',
                strHp,
                ', "max_value":',
                strMaxHp,
                '}, { "trait_type": "Attack Damage", "value": ',
                strAttackDamage,
                "} ]}"
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        return output;
    }

    // Users hit this function to get their NFT based on the
    // characterId they send in
    function mintCharacterNFT(uint256 _characterIndex) external {
        // Get current tokenId (starts at 1 since we incremented in the constructor)
        uint256 newItemId = _tokenIds.current();

        // assign the tokenId to the caller's wallet address
        _safeMint(msg.sender, newItemId);

        // Map the tokenId => this character's attributes.
        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            weapon: defaultCharacters[_characterIndex].weapon,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].maxHp,
            attackDamage: defaultCharacters[_characterIndex].attackDamage
        });

        console.log(
            "Minted NFT w/tokenId %s and characterIndex %s",
            newItemId,
            _characterIndex
        );

        // Keep an easy way to see who owns what NFT
        nftHolders[msg.sender] = newItemId;

        // Increment the tokenId for the next person that uses it.
        _tokenIds.increment();
    }
}
