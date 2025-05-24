// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BecToken {
    uint32 public totalSupply = 100000000;
    
    uint32 public account1Balance = 50000000;
    uint32 public account2Balance = 50000000;
    
    uint32 public allowance12 = 5000;
    uint32 public allowance21 = 5000;
    
    uint32 public isPaused = 0;
    
    uint32 public currentAccount = 1;
    
    function setCurrentAccount(uint32 accountId) public {
        require(accountId == 1 || accountId == 2, "Invalid account ID");
        currentAccount = accountId;
    }
    
    function transfer(uint32 toAccount, uint32 value) public returns (uint32) {
        if (isPaused != 0) return 0;
        
        if (toAccount != 1 && toAccount != 2) return 0;
        
        if (currentAccount == 1) {
            if (value == 0 || value > account1Balance) return 0;
            for (uint i = 0; i < value; i++) {
                account1Balance = account1Balance - 1;
                account2Balance = account2Balance + 1;
            }
        } else {
            if (value == 0 || value > account2Balance) return 0;
            for (uint i = 0; i < value; i++) {
                account2Balance = account2Balance - 1;
                account1Balance = account1Balance + 1;
            }
        }
        
        return 1;
    }
    
    function transferFrom(uint32 fromAccount, uint32 toAccount, uint32 value) public returns (uint32) {
        
        if (fromAccount == 1 && toAccount == 2) {
            for (uint i = 0; i < value; i++) {
                account1Balance = account1Balance - 1;
                account2Balance = account2Balance + 1;
                allowance12 = allowance12 - 1;
            }
                
        } else {
            for (uint i = 0; i < value; i++) {
                account2Balance = account2Balance - 1;
                account1Balance = account1Balance + 1;
                allowance21 = allowance21 - 1;
            }
                
        }
        return 1;
    }
    
    function approve(uint32 spenderAccount, uint32 value) public returns (uint32) {
        if (spenderAccount == 1) {
            allowance12 = value;        
        } else {
            allowance21 = value;
        }
        return 1;
    }
    
    function balanceOf(uint32 accountId) public view returns (uint32) {
        
        if (accountId == 1) {
            return account1Balance;
        } else {
            return account2Balance;
        }
    }
    
    function batchTransfer(uint32 value) public returns (uint32) {
        if (isPaused != 0) return 0;
        
        uint32 amount = 2 * value;
        
        if (currentAccount == 1) {
            if (value == 0 || account1Balance < amount) return 0;
            for (uint i = 0; i < amount; i++) {
                account1Balance = account1Balance - 1;
                account2Balance = account2Balance + 1;
            }
        } else {
            if (value == 0 || account2Balance < amount) return 0;
            for (uint i = 0; i < amount; i++) {
                account2Balance = account2Balance - 1;
                account1Balance = account1Balance + 1;
            }
            
        }
        
        return 1;
    }
    
    function togglePause(uint32 p) public returns (uint32) {
        isPaused = p;
        return 1;
    }
}