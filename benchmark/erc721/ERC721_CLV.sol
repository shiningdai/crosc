// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Clovers {
    // uint32 constant private ACCOUNT_1 = 1;
    // uint32 constant private ACCOUNT_2 = 2;

    uint32 public owner = 1;
    uint32 public cloversController = 2;
    uint32 public clubTokenController = 2;

    struct Token {
        uint32 owner;
        uint32 keep;
        uint32 symmetries;
        uint32 blockMinted;
        uint32 rewards;
        uint32 move1;
        uint32 move2;
        uint32 approved;
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


    function query(uint32 id, uint8 queryType) public view returns (uint32) {
        if (queryType == 0) return tokens[id].owner != 0 ? 1 : 0;
        if (queryType == 1) return tokens[id].owner;
        if (queryType == 2) return balances[id];
        return 0;
    }

    function getAttr(uint32 tokenId, uint32 attr) public view returns (uint32) {
        if (attr == 1) return tokens[tokenId].keep;
        if (attr == 2) return tokens[tokenId].blockMinted;
        if (attr == 3) return tokens[tokenId].move1;
        if (attr == 4) return tokens[tokenId].move2;
        if (attr == 5) return tokens[tokenId].rewards;
        if (attr == 6) return tokens[tokenId].symmetries;
        if (attr == 7) return tokens[tokenId].approved;
        return 0;
    }

    function setAttr(uint32 tokenId, uint32 attr, uint32 value) public {
        if (attr == 1) tokens[tokenId].keep = value;
        else if (attr == 2) tokens[tokenId].blockMinted = value;
        else if (attr == 3) tokens[tokenId].move1 = value;
        else if (attr == 4) tokens[tokenId].move2 = value;
        else if (attr == 5) tokens[tokenId].rewards = value;
        else if (attr == 6) tokens[tokenId].symmetries = value;
        else if (attr == 7) tokens[tokenId].approved = value;
    }

    function mintToken(uint32 to, uint32 tokenId) public {
        tokens[tokenId].owner = to;
        balances[to]++;
    }

    function burnToken(uint32 tokenId) public {
        uint32 from = tokens[tokenId].owner;
        if (from != 0) {
            balances[from]--;
            delete tokens[tokenId];
        }
    }

    function transfer(uint32 to, uint32 tokenId) public {
        uint32 from = tokens[tokenId].owner;
        if (from != 0) {
            tokens[tokenId].owner = to;
            tokens[tokenId].approved = 0;
            balances[from]--;
            balances[to]++;
        }
    }

    function balanceOf(uint32 id) public view returns (uint32) {
        return balances[id];
    }
}
