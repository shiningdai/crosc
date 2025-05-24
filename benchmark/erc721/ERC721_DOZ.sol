// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DozerDoll {
    uint32 public totalTokens = 1000000;
    
    struct Token {
        uint32 owner;
        uint32 symmetry;
        uint32 reward;
        uint32 block;
        uint32 keep;
    }
    
    mapping(uint32 => Token) public tokens;
    mapping(uint32 => uint32) public balances;
    uint256 private _init = _initializeBalances();
    function _initializeBalances() private returns (uint256) {
        balances[0] = 600000;
        balances[1] = 200000;
        balances[2] = 200000;
        return 1;
    }
    
    struct SymmetryData {
        uint32 total;
        uint32 rotSym;
        uint32 y0Sym;
        uint32 x0Sym;
        uint32 xySym;
        uint32 xnySym;
    }
    
    SymmetryData public symmetryData;
    
    
    function manageToken(uint32 from, uint32 to, uint32 tokenParam) public returns (uint32) {
        uint32 tokenId = tokenParam / 10;
        uint32 operation = tokenParam % 10;
        
        if (operation == 0) {
            uint32 owner = tokens[tokenId].owner;
            if (owner == 0) return 0;
            if (owner != from) return 0;
            
            tokens[tokenId].owner = to;
            
            balances[from] -= 1;
            balances[to] += 1;
        } else if (operation == 1) {
            if (tokens[tokenId].owner != 0) return 0;
            
            tokens[tokenId].owner = to;
            balances[to] += 1;
            
        } else if (operation == 2) {
            uint32 owner = tokens[tokenId].owner;
            if (owner == 0) return 0;
            if (owner != from) return 0;
            
            delete tokens[tokenId];
            balances[from] -= 1;
        }
        
        return 0;
    }
    
    function getProperty(uint32 tokenId, uint32 propertyType) public view returns (uint32) {
        if (propertyType == 0) {
            return tokens[tokenId].symmetry;
        } else if (propertyType == 1) {
            return tokens[tokenId].reward;
        } else if (propertyType == 2) {
            return tokens[tokenId].block;
        } else if (propertyType == 3) {
            return tokens[tokenId].keep;
        }
        return 0;
    }
    
    function setProperty(uint32 tokenId, uint32 valueParam) public {
        uint32 value = valueParam / 10;
        uint32 propertyType = valueParam % 10;
        
        if (propertyType == 0) {
            tokens[tokenId].symmetry = value;
        } else if (propertyType == 1) {
            tokens[tokenId].reward = value;
        } else if (propertyType == 2) {
            tokens[tokenId].block = value;
        } else if (propertyType == 3) {
            tokens[tokenId].keep = value;
        }
    }
    
    function getSymValue(uint32 index) public view returns (uint32) {
        if (index == 0) return symmetryData.total;
        if (index == 1) return symmetryData.rotSym;
        if (index == 2) return symmetryData.y0Sym;
        if (index == 3) return symmetryData.x0Sym;
        if (index == 4) return symmetryData.xySym;
        if (index == 5) return symmetryData.xnySym;
        return 0;
    }
    
    function setSymValue(uint32 index, uint32 value) public {
        if (index == 0) symmetryData.total = value;
        if (index == 1) symmetryData.rotSym = value;
        if (index == 2) symmetryData.y0Sym = value;
        if (index == 3) symmetryData.x0Sym = value;
        if (index == 4) symmetryData.xySym = value;
        if (index == 5) symmetryData.xnySym = value;
    }
    
    function totalSupply() public view returns (uint32) {
        return totalTokens;
    }
}