// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract MyEpicGame {
    struct CharacterAttributes {
        uint256 characterIndex;
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    // An array to help hold default data for all characters
    // Helpful when we mint new characters
    // to know their HP, AD, etc.
    CharacterAttributes[] defaultCharacters;

    // Data passed into the contract when it's first created initializing the characters.
    // We're going to actually pass these values in from run.js

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg
    ) 
    {
        // Loop through all the characters and save their values in our contract
        // so that we can use them later when we mint our NFTs.
        for(uint i = 0; i < characterNames.length; i+=1) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                hp: characterHp[i],
                maxHp: characterHp[i],
                attackDamage: characterAttackDmg[i]
            }));

            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done initializing %s w/HP %s, img %s", c.name, c.hp, c.imageURI);
        }

    }
}
