// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EggStorage {
    uint32 public owner = 1;
    
    struct Egg {
        uint32 owner;
        uint32 parent1;
        uint32 parent2;
        uint32 dragonType;
        uint32 approval;
    }
    
    mapping(uint32 => Egg) public eggs;
    mapping(uint32 => uint32) public balances;
    uint256 private _init = _initializeBalances();
    function _initializeBalances() private returns (uint256) {
        balances[0] = 600000;
        balances[1] = 200000;
        balances[2] = 200000;
        return 1;
    }
    mapping(uint32 => mapping(uint32 => uint32)) public accountApproves;
    
    function manageEgg(uint32 eggId, uint32 param, uint32 opType) public {
        // opType: 0 = setParents, 1 = setDragonType
        if (opType == 0) {
            uint32 parent1 = param / 10;
            uint32 parent2 = param % 10;
            eggs[eggId].parent1 = parent1;
            eggs[eggId].parent2 = parent2;
        } else if (opType == 1) {
            eggs[eggId].dragonType = param;
        }
    }
    
    function push(uint32 sender, uint32 eggId) public returns (uint32) {
        eggs[eggId].owner = sender;
        balances[sender] = balances[sender] + 1;
        return eggId;
    }
    
    function getEggProperty(uint32 eggId, uint32 propertyType) public view returns (uint32) {
        if (propertyType == 0) return eggs[eggId].parent1;
        if (propertyType == 1) return eggs[eggId].parent2;
        if (propertyType == 2) return eggs[eggId].dragonType;
        if (propertyType == 3) return eggs[eggId].owner;
        if (propertyType == 4) return eggs[eggId].approval;
        return 0;
    }
    
    function remove(uint32 ownerAccount, uint32 eggId) public {
        uint32 currentOwner = eggs[eggId].owner;
        
        if (currentOwner != ownerAccount) {
            return;
        }
        
        eggs[eggId].parent1 = 0;
        eggs[eggId].parent2 = 0;
        eggs[eggId].dragonType = 0;
        eggs[eggId].owner = 0;
        eggs[eggId].approval = 0;
        
        balances[ownerAccount] = balances[ownerAccount] - 1;
    }
    
    function tokenOperation(uint32 toAccount, uint32 tokenId, uint32 opType) public {
        // opType: 0 = mint, 1 = transferFrom
        if (opType == 0) {
            if (eggs[tokenId].owner != 0) {
                return;
            }
            eggs[tokenId].parent1 = 1;
            eggs[tokenId].parent2 = 1;
            eggs[tokenId].dragonType = 1;
            eggs[tokenId].owner = toAccount;
            
            balances[toAccount] = balances[toAccount] + 1;
            
        } else if (opType == 1) {
            uint32 fromAccount = eggs[tokenId].owner;
            
            if (fromAccount == 0) {
                return;
            }
            
            eggs[tokenId].owner = toAccount;
            
            balances[fromAccount] = balances[fromAccount] - 1;
            balances[toAccount] = balances[toAccount] + 1;
        }
    }
    
    function balanceOf(uint32 accountId) public view returns (uint32) {
        return balances[accountId];
    }
}