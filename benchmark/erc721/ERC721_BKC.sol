// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockCities {
    
    struct Building {
        uint32 owner;
        uint32 extColorway;
        uint32 bgColorway;
        uint32 city;
        uint32 building;
        uint32 base;
        uint32 body;
        uint32 roof;
        uint32 special;
        uint32 architect;
        uint32 exists;
    }
    
    mapping(uint32 => Building) public buildings;
    mapping(uint32 => uint32) public balances;
    uint256 private _init = _initializeBalances();
    function _initializeBalances() private returns (uint256) {
        balances[0] = 600000;
        balances[1] = 200000;
        balances[2] = 200000;
        return 1;
    }
    
    function setAttribute(uint32 tokenId, uint32 value, uint32 attrIndex) public {
        if (attrIndex == 0) buildings[tokenId].extColorway = value;
        else if (attrIndex == 1) buildings[tokenId].bgColorway = value;
        else if (attrIndex == 2) buildings[tokenId].city = value;
        else if (attrIndex == 3) buildings[tokenId].building = value;
        else if (attrIndex == 4) buildings[tokenId].base = value;
        else if (attrIndex == 5) buildings[tokenId].body = value;
        else if (attrIndex == 6) buildings[tokenId].roof = value;
        else if (attrIndex == 7) buildings[tokenId].special = value;
        else if (attrIndex == 8) buildings[tokenId].architect = value;
    }
    
    
    function mint(uint32 tokenId, uint32 to) public returns (uint32) {
        if (buildings[tokenId].exists == 0) {
            buildings[tokenId].exists = 1;
            buildings[tokenId].owner = to;
            balances[to] = balances[to] + 1;
            
            return tokenId;
        }
        
        return 0;
    }
    
    function getAttribute(uint32 tokenId, uint32 attrIndex) public view returns (uint32) {
        if (buildings[tokenId].exists != 1) return 0;
        
        if (attrIndex == 0) return buildings[tokenId].extColorway;
        if (attrIndex == 1) return buildings[tokenId].bgColorway;
        if (attrIndex == 2) return buildings[tokenId].city;
        if (attrIndex == 3) return buildings[tokenId].building;
        if (attrIndex == 4) return buildings[tokenId].base;
        if (attrIndex == 5) return buildings[tokenId].body;
        if (attrIndex == 6) return buildings[tokenId].roof;
        if (attrIndex == 7) return buildings[tokenId].special;
        if (attrIndex == 8) return buildings[tokenId].architect;
        
        return 0;
    }
    
    function queryToken(uint32 idOrAccount, uint32 queryType) public view returns (uint32) {
        if (queryType == 1) {
            return balances[idOrAccount];
        } else {
            if (buildings[idOrAccount].exists == 1) {
                return buildings[idOrAccount].owner;
            }
            return 0;
        }
    }
    
    function transfer(uint32 from, uint32 to, uint32 tokenId) public returns (uint32) {
        if (buildings[tokenId].exists != 1 || buildings[tokenId].owner != from) {
            return 0;
        }

        buildings[tokenId].owner = to;

        balances[from] = balances[from] - 1;
        balances[to] = balances[to] + 1;

        return 1;
    }

    function burn(uint32 from, uint32 tokenId) public returns (uint32) {
        if (buildings[tokenId].exists != 1 || buildings[tokenId].owner != from) {
            return 0;
        }

        balances[from] = balances[from] - 1;
        delete buildings[tokenId];

        return 1;
    }

    
    function supplyInfo(uint32 tokenId) public view returns (uint32) {
        return buildings[tokenId].exists;
    }
}