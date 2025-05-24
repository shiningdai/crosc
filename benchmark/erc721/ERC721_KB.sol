// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KingdomsBeyond {

    mapping(uint32 => uint32) public balances;
    mapping(uint32 => uint32) public owners;
    uint256 private _init = _initializeBalances();
    function _initializeBalances() private returns (uint256) {
        for (uint32 i = 1; i <= 50; i++) {
            owners[i] = 1;
        }
        for (uint32 i = 51; i <= 100; i++) {
            owners[i] = 2;
        }
        balances[1] = 50;
        balances[2] = 50;
        return 1;
    }

    function mint(uint32 accountId, uint32 newTokenId) public {
        owners[newTokenId] = accountId;
        balances[accountId] += 1;
    }

    function burn(uint32 tokenId) public {
        uint32 owner = owners[tokenId];
        balances[owner] -= 1;
    }

    function transfer(uint32 fromAccount, uint32 toAccount, uint32 tokenId) public {
        owners[tokenId] = toAccount;
        balances[fromAccount] -= 1;
        balances[toAccount] += 1;
    }

    function getOwner(uint32 tokenId) public view returns (uint32) {
        return owners[tokenId];
    }

    function balanceOf(uint32 accountId) public view returns (uint32) {
        return balances[accountId];
    }
}
