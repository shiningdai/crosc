// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ZRXToken {
    uint32 public _totalSupply = 1000000;
    uint32 public decimals = 8;

    uint32 public constant ownerID = 1;
    uint32 public constant user1ID = 2;
    uint32 public constant user2ID = 3;


    mapping(uint32 => uint32) public balances;

    uint256 private _init = _initializeBalances();

    function _initializeBalances() private returns (uint256) {
        balances[ownerID] = 600000;
        balances[user1ID] = 200000;
        balances[user2ID] = 200000;
        return 1;
    }

    mapping(uint32 => mapping(uint32 => uint32)) public allowances;

    function balanceOf(uint32 userID) public view returns (uint32) {
        return balances[userID];
    }

    function transfer(uint32 fromID, uint32 toID, uint32 value) public returns (bool) {
        balances[fromID] -= value;
        balances[toID] += value;
        return true;
    }

    function approve(uint32 tokenOwnerID, uint32 spenderID, uint32 value) public returns (bool) {
        if (
            (tokenOwnerID == ownerID && (spenderID == user1ID || spenderID == user2ID)) ||
            (tokenOwnerID == user1ID && (spenderID == ownerID || spenderID == user2ID)) ||
            (tokenOwnerID == user2ID && (spenderID == ownerID || spenderID == user1ID))
        ) {
            allowances[tokenOwnerID][spenderID] = value;
            return true;
        }
        return false;
    }

    function allowance(uint32 tokenOwnerID, uint32 spenderID) public view returns (uint32) {
        return allowances[tokenOwnerID][spenderID];
    }

    function totalSupply() public view returns (uint32) {
        return _totalSupply;
    }
}
