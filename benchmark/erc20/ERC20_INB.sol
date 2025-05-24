// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InsightChainToken {
    uint32 public totalSupply = 1000000;
    uint32 public decimals = 8;
    
    uint32 public balance = 1000000;
    uint32 public allow = 5000;
    
    function transfer(uint32 _value) public returns (bool) {
        require(_value <= balance);
        for (uint i = 0; i < _value; i++) {
            balance = balance - 1;
        }
        return true;
    }
    
    function approve(uint32 _value) public returns (bool) {
        balance -= _value;
        return true;
    }
    
    function allowance() public view returns (uint32) {
        return allow;
    }
    
    function balanceOf() public view returns (uint32) {
        return balance;
    }
}