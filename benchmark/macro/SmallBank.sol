// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmallBank {
    uint32 savingStore0 = 0;
    uint32 savingStore1 = 0;
    uint32 savingStore2 = 0;
    
    uint32 checkingStore0 = 1000;
    uint32 checkingStore1 = 1000;
    uint32 checkingStore2 = 1000;
    
    uint32 accountExists0 = 0;
    uint32 accountExists1 = 0;
    uint32 accountExists2 = 0;
    
    uint32 MAX_ACCOUNTS = 3;
    uint32 totalAccounts = 0;
    
    uint32 currBalance = 0;
    uint32 currAccount = 0;
    uint32 loopCounter = 0;
    uint32 lastAmount = 0;
    uint32 savingBalance = 0;
    uint32 stepAmount = 100;
    uint32 lastIndex = 0;
    
    
    function almagate(uint32 fromAccount, uint32 toAccount) public {
        // Direct implementation of getting saving and checking store
        if (fromAccount == 0) currBalance = savingStore0;
        else if (fromAccount == 1) currBalance = savingStore1;
        else if (fromAccount == 2) currBalance = savingStore2;
        
        if (toAccount == 0) currBalance += checkingStore0;
        else if (toAccount == 1) currBalance += checkingStore1;
        else if (toAccount == 2) currBalance += checkingStore2;
       
        // Loop that reads/writes state variables
        loopCounter = totalAccounts % 3 + 1;
        lastIndex = 0;
        while (lastIndex < loopCounter) {
            currAccount = (fromAccount + lastIndex) % (totalAccounts + 1);
            
            // Check if account exists
            uint32 accountExistsValue = 0;
            if (currAccount == 0) accountExistsValue = accountExists0;
            else if (currAccount == 1) accountExistsValue = accountExists1;
            else if (currAccount == 2) accountExistsValue = accountExists2;
            
            if(accountExistsValue > 0) {
                // Some dummy operations to read/write state
                uint32 val = 0;
                if (currAccount == 0) val = savingStore0;
                else if (currAccount == 1) val = savingStore1;
                else if (currAccount == 2) val = savingStore2;
                
                // Update savings
                if (currAccount == 0) {
                    savingStore0 = val + 1;
                    savingStore0 = val;
                } else if (currAccount == 1) {
                    savingStore1 = val + 1;
                    savingStore1 = val;
                } else if (currAccount == 2) {
                    savingStore2 = val + 1;
                    savingStore2 = val;
                }
            }
            lastIndex += 1;
        }
       
        // Set checking store for fromAccount
        if (fromAccount == 0) checkingStore0 = 0;
        else if (fromAccount == 1) checkingStore1 = 0;
        else if (fromAccount == 2) checkingStore2 = 0;
        
        // Set saving store for toAccount
        if (toAccount == 0) savingStore0 = currBalance;
        else if (toAccount == 1) savingStore1 = currBalance;
        else if (toAccount == 2) savingStore2 = currBalance;
    }

    function getBalance(uint32 accountId) public returns (uint32) {
        // Get saving and checking store values
        if (accountId == 0) {
            currBalance = savingStore0 + checkingStore0;
        } else if (accountId == 1) {
            currBalance = savingStore1 + checkingStore1;
        } else if (accountId == 2) {
            currBalance = savingStore2 + checkingStore2;
        }
        
        // Loop through accounts
        uint32 sum = 0;
        lastIndex = 0;
        while (lastIndex < totalAccounts && lastIndex < 3) {
            uint32 accountExistsValue = 0;
            if (lastIndex == 0) accountExistsValue = accountExists0;
            else if (lastIndex == 1) accountExistsValue = accountExists1;
            else if (lastIndex == 2) accountExistsValue = accountExists2;
            
            if(accountExistsValue > 0) {
                if (lastIndex == 0) sum += savingStore0 + checkingStore0;
                else if (lastIndex == 1) sum += savingStore1 + checkingStore1;
                else if (lastIndex == 2) sum += savingStore2 + checkingStore2;
            }
            lastIndex += 1;
        }
        
        return currBalance;
    }
    
    function updateBalance(uint32 accountId, uint32 depositAmount) public returns (uint32) {
        if (accountId == 0) currBalance = checkingStore0;
        else if (accountId == 1) currBalance = checkingStore1;
        else if (accountId == 2) currBalance = checkingStore2;
        
        lastAmount = depositAmount;
        while (lastAmount > stepAmount) {
            currBalance += stepAmount;
            lastAmount -= stepAmount;
        }
        currBalance += lastAmount;

        if (accountId == 0) checkingStore0 = currBalance;
        else if (accountId == 1) checkingStore1 = currBalance;
        else if (accountId == 2) checkingStore2 = currBalance;
        lastAmount = depositAmount;
        return lastAmount;
    }
    
    function updateSaving(uint32 accountId, uint32 depositAmount) public {
        // Get saving store value
        if (accountId == 0) currBalance = savingStore0;
        else if (accountId == 1) currBalance = savingStore1;
        else if (accountId == 2) currBalance = savingStore2;
        
        lastAmount = depositAmount;
        
        // Loop with more complex state var interactions
        loopCounter = totalAccounts % 3 + 1;
        lastIndex = 0;
        while (lastIndex < loopCounter) {
            currAccount = (accountId + lastIndex) % (totalAccounts + 1);
            
            uint32 accountExistsValue = 0;
            if (currAccount == 0) accountExistsValue = accountExists0;
            else if (currAccount == 1) accountExistsValue = accountExists1;
            else if (currAccount == 2) accountExistsValue = accountExists2;
            
            uint32 savingValue = 0;
            if (currAccount == 0) savingValue = savingStore0;
            else if (currAccount == 1) savingValue = savingStore1;
            else if (currAccount == 2) savingValue = savingStore2;
            
            if(accountExistsValue > 0 && savingValue > 100) {
                // Update saving store
                if (currAccount == 0) {
                    savingStore0 = savingValue + 10;
                    savingStore0 = savingValue;
                } else if (currAccount == 1) {
                    savingStore1 = savingValue + 10;
                    savingStore1 = savingValue;
                } else if (currAccount == 2) {
                    savingStore2 = savingValue + 10;
                    savingStore2 = savingValue;
                }
            }
            lastIndex += 1;
        }
        
        // Set saving store for accountId
        if (accountId == 0) savingStore0 = currBalance + lastAmount;
        else if (accountId == 1) savingStore1 = currBalance + lastAmount;
        else if (accountId == 2) savingStore2 = currBalance + lastAmount;
    }
    
    function sendPayment(uint32 fromAccount, uint32 toAccount, uint32 paymentAmount) public {
        // Get checking store value for source account
        if (fromAccount == 0) currBalance = checkingStore0;
        else if (fromAccount == 1) currBalance = checkingStore1;
        else if (fromAccount == 2) currBalance = checkingStore2;
        
        lastAmount = paymentAmount;
        
        // Loop with state reads/writes
        loopCounter = totalAccounts % 3 + 1;
        lastIndex = 0;
        while (lastIndex < loopCounter) {
            currAccount = (fromAccount + lastIndex) % (totalAccounts + 1);
            
            uint32 accountExistsValue = 0;
            if (currAccount == 0) accountExistsValue = accountExists0;
            else if (currAccount == 1) accountExistsValue = accountExists1;
            else if (currAccount == 2) accountExistsValue = accountExists2;
            
            uint32 checkingValue = 0;
            if (currAccount == 0) checkingValue = checkingStore0;
            else if (currAccount == 1) checkingValue = checkingStore1;
            else if (currAccount == 2) checkingValue = checkingStore2;
            
            if(accountExistsValue > 0 && checkingValue > lastAmount / 2) {
                // Dummy operations
                if (currAccount == 0) {
                    checkingStore0 = checkingValue + 5;
                    checkingStore0 = checkingValue;
                } else if (currAccount == 1) {
                    checkingStore1 = checkingValue + 5;
                    checkingStore1 = checkingValue;
                } else if (currAccount == 2) {
                    checkingStore2 = checkingValue + 5;
                    checkingStore2 = checkingValue;
                }
            }
            lastIndex += 1;
        }
        
        // Update source account
        if (fromAccount == 0) checkingStore0 = currBalance - lastAmount;
        else if (fromAccount == 1) checkingStore1 = currBalance - lastAmount;
        else if (fromAccount == 2) checkingStore2 = currBalance - lastAmount;
        
        // Update destination account
        if (toAccount == 0) checkingStore0 += lastAmount;
        else if (toAccount == 1) checkingStore1 += lastAmount;
        else if (toAccount == 2) checkingStore2 += lastAmount;
    }
    
    function writeCheck(uint32 accountId, uint32 checkAmount) public {
        // Get checking and saving store values
        if (accountId == 0) {
            currBalance = checkingStore0;
            savingBalance = savingStore0;
        } else if (accountId == 1) {
            currBalance = checkingStore1;
            savingBalance = savingStore1;
        } else if (accountId == 2) {
            currBalance = checkingStore2;
            savingBalance = savingStore2;
        }
        
        lastAmount = checkAmount;
        
        // Complex loop with state reads/writes
        loopCounter = totalAccounts % 3 + 1;
        lastIndex = 0;
        while (lastIndex < loopCounter) {
            currAccount = (accountId + lastIndex) % (totalAccounts + 1);
            
            uint32 accountExistsValue = 0;
            if (currAccount == 0) accountExistsValue = accountExists0;
            else if (currAccount == 1) accountExistsValue = accountExists1;
            else if (currAccount == 2) accountExistsValue = accountExists2;
            
            if(accountExistsValue > 0) {
                uint32 checkBal = 0;
                uint32 saveBal = 0;
                
                if (currAccount == 0) {
                    checkBal = checkingStore0;
                    saveBal = savingStore0;
                } else if (currAccount == 1) {
                    checkBal = checkingStore1;
                    saveBal = savingStore1;
                } else if (currAccount == 2) {
                    checkBal = checkingStore2;
                    saveBal = savingStore2;
                }
                
                if(checkBal < saveBal) {
                    if (currAccount == 0) {
                        savingStore0 = saveBal - 1;
                        checkingStore0 = checkBal + 1;
                    } else if (currAccount == 1) {
                        savingStore1 = saveBal - 1;
                        checkingStore1 = checkBal + 1;
                    } else if (currAccount == 2) {
                        savingStore2 = saveBal - 1;
                        checkingStore2 = checkBal + 1;
                    }
                } else {
                    if (currAccount == 0) {
                        checkingStore0 = checkBal - 1;
                        savingStore0 = saveBal + 1;
                    } else if (currAccount == 1) {
                        checkingStore1 = checkBal - 1;
                        savingStore1 = saveBal + 1;
                    } else if (currAccount == 2) {
                        checkingStore2 = checkBal - 1;
                        savingStore2 = saveBal + 1;
                    }
                }
            }
            lastIndex += 1;
        }
        
        if (lastAmount < currBalance + savingBalance) {
            if (accountId == 0) checkingStore0 = currBalance - lastAmount - 1;
            else if (accountId == 1) checkingStore1 = currBalance - lastAmount - 1;
            else if (accountId == 2) checkingStore2 = currBalance - lastAmount - 1;
        } else {
            if (accountId == 0) checkingStore0 = currBalance - lastAmount;
            else if (accountId == 1) checkingStore1 = currBalance - lastAmount;
            else if (accountId == 2) checkingStore2 = currBalance - lastAmount;
        }
    }
    
    // Create account function
    function createAccount(uint32 accountId, uint32 initialSaving, uint32 initialChecking) public {
        // Make sure we're not overwriting an existing account
        uint32 accountExistsValue = 0;
        if (accountId == 0) accountExistsValue = accountExists0;
        else if (accountId == 1) accountExistsValue = accountExists1;
        else if (accountId == 2) accountExistsValue = accountExists2;
        
        require(accountExistsValue == 0, "Account already exists");
        require(accountId < MAX_ACCOUNTS, "Account ID exceeds maximum limit");
        
        // Loop with state var operations for testing
        loopCounter = totalAccounts % 3 + 1;
        lastIndex = 0;
        while (lastIndex < loopCounter) {
            currAccount = lastIndex % (totalAccounts + 1);
            
            accountExistsValue = 0;
            if (currAccount == 0) accountExistsValue = accountExists0;
            else if (currAccount == 1) accountExistsValue = accountExists1;
            else if (currAccount == 2) accountExistsValue = accountExists2;
            
            if(accountExistsValue > 0) {
                // Dummy operations to stress test
                uint32 val = 0;
                if (currAccount == 0) val = savingStore0;
                else if (currAccount == 1) val = savingStore1;
                else if (currAccount == 2) val = savingStore2;
                
                // Update saving store
                if (currAccount == 0) {
                    savingStore0 = val + 1;
                    savingStore0 = val;
                } else if (currAccount == 1) {
                    savingStore1 = val + 1;
                    savingStore1 = val;
                } else if (currAccount == 2) {
                    savingStore2 = val + 1;
                    savingStore2 = val;
                }
            }
            lastIndex += 1;
        }
        
        // Set account data
        if (accountId == 0) {
            accountExists0 = 1;
            savingStore0 = initialSaving;
            checkingStore0 = initialChecking;
        } else if (accountId == 1) {
            accountExists1 = 1;
            savingStore1 = initialSaving;
            checkingStore1 = initialChecking;
        } else if (accountId == 2) {
            accountExists2 = 1;
            savingStore2 = initialSaving;
            checkingStore2 = initialChecking;
        }
        
        totalAccounts += 1;
    }
}