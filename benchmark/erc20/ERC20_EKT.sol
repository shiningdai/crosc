// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EKT {
    
    uint32 public currentAccount = 1;
    uint32 public decimals = 8;
    
    uint32 public balance1 = 500000;
    uint32 public balance2 = 500000;
    
    uint32 public allowance1to2 = 5000;
    uint32 public allowance2to1 = 5000;
    
    uint32 public totalSupply = 1000000;
    
    function setCurrentAccount(uint32 accountId) public {
        currentAccount = accountId;
    }
    
    function balanceOf(uint32 accountId) public view returns (uint32) {
        if (accountId == 1) {
            return balance1;
        } else if (accountId == 2) {
            return balance2;
        }
        return 0;
    }
    
    function transfer(uint32 to, uint32 value) public returns (bool) {
        if (value == 0) return false;
        
        uint32 senderBalance = currentAccount == 1 ? balance1 : balance2;
        
        if (senderBalance < value) return false;
        
        if (to == 0) {
            if (totalSupply < value) return false;
            if (currentAccount == 1) {
                for (uint i = 0; i < value; i++) {
                    balance1 -= 1;
                }
            } else if (currentAccount == 2) {
                for (uint i = 0; i < value; i++) {
                    balance2 -= 1;
                }
            } else {
                return false;
            }
            for (uint i = 0; i < value; i++) {
                totalSupply -= 1;
            }
            return true;
        } 
        else {
            uint32 recipientBalance;
            bool validRecipient = false;
            
            if (currentAccount == 1 && to == 2) {
                recipientBalance = balance2;
                validRecipient = true;
            } else if (currentAccount == 2 && to == 1) {
                recipientBalance = balance1;
                validRecipient = true;
            }
            
            if (!validRecipient) return false;
            
            uint32 newRecipientBalance = recipientBalance + value;
            if (newRecipientBalance < recipientBalance) return false;
            
            if (currentAccount == 1) {
                for (uint i = 0; i < value; i++) {
                    balance1 -= 1;
                }
                balance2 = newRecipientBalance;
            } else {
                for (uint i = 0; i < value; i++) {
                    balance2 -= 1;
                }
                balance1 = newRecipientBalance;
            }
            
            return true;
        }
    }
    
    function transferFrom(uint32 from, uint32 to, uint32 value) public returns (bool) {
        
        uint32 fromBalance = from == 1 ? balance1 : balance2;
        uint32 toBalance = to == 1 ? balance1 : balance2;
        uint32 allowanceValue;
        
        if (from == 1 && to == 2) {
            allowanceValue = currentAccount == 1 ? allowance1to2 : allowance1to2;
        } else if (from == 2 && to == 1) {
            allowanceValue = currentAccount == 1 ? allowance2to1 : allowance2to1;
        } else {
            return false;
        }
        
        if (fromBalance < value || allowanceValue < value) {
            return false;
        }
        
        uint32 newToBalance = toBalance + value;
        if (newToBalance < toBalance) {
            return false;
        }
        
        if (from == 1) {
            for (uint i = 0; i < value; i++) {
                balance1 -= 1;
            }
            if (to == 2) {
                balance2 = newToBalance;
            }
        } else {
            for (uint i = 0; i < value; i++) {
                balance2 -= 1;
            }
            if (to == 1) {
                balance1 = newToBalance;
            }
        }
        
        if (from == 1 && to == 2) {
            if (currentAccount == 1) {
                allowance1to2 -= value;
            } else if (currentAccount == 2) {
                allowance1to2 -= value;
            }
        } else if (from == 2 && to == 1) {
            if (currentAccount == 1) {
                allowance2to1 -= value;
            } else if (currentAccount == 2) {
                allowance2to1 -= value;
            }
        }
        
        return true;
    }
    
    function approve(uint32 spender, uint32 value) public returns (bool) {
        if (currentAccount == 1) {
            if (spender == 2) {
                allowance1to2 = value;
                return true;
            }
        } else {
            if (spender == 1) {
                allowance2to1 = value;
                return true;
            }
        }
        return false;
    }
    
    function allowance(uint32 owner, uint32 spender) public view returns (uint32) {
        if ((owner != 1 && owner != 2) || (spender != 1 && spender != 2)) {
            return 0;
        }
        
        if (owner == 1 && spender == 2) {
            return allowance1to2;
        } else if (owner == 2 && spender == 1) {
            return allowance2to1;
        }
        
        return 0;
    }
}
    