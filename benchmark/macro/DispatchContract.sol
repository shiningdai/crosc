// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DispatchContract {
    uint128 public owner = 0;
    uint128 public customParam = 0;
    
    uint128 public loopCounter = 0;
    uint128 public totalOperations = 0;
    uint128 public lastOperationValue = 0;
    uint128 public maxIterations = 10;
    uint128 public accumulatedValue = 0;

    uint128 public withdrawnAmount = 0;
    uint128 public transferTarget1 = 0;
    uint128 public transferTarget2 = 0;
    uint128 public lastTransferAmount1 = 0;
    uint128 public lastTransferAmount2 = 0;
    uint128 public transferSuccess = 1;

    // initial contract balance
    uint128 public contractBalance = 1000;
    uint128 public stepWithdraw = 10;

    function transferOwnership(uint128 newOwner) public {
        require(newOwner != 0, "New owner is zero address");
        
        for (loopCounter = 0; loopCounter < maxIterations; loopCounter++) {
            totalOperations += 1;
            accumulatedValue += loopCounter;
            lastOperationValue = owner + newOwner + loopCounter;
        }
        
        owner = newOwner;
    }

    function receive_eth(uint128 value) public {
        contractBalance += value;
        
        for (loopCounter = 0; loopCounter < maxIterations; loopCounter++) {
            totalOperations += 1;
            customParam = (customParam + 1) % 1000;
            lastOperationValue = value + loopCounter;
        }
    }

    function topUp(uint128 value) public {
        contractBalance += value;
        
        loopCounter = 0;
        while (loopCounter < maxIterations) {
            customParam = (customParam + 1) % 1000;
            lastOperationValue = value * (loopCounter + 1);
            totalOperations += 1;
            loopCounter += 1;
        }
    }

    function updateLimit(uint128 _param) public {
        loopCounter = 0;
        while (loopCounter < maxIterations) {
            lastOperationValue = _param * (loopCounter + 1);
            totalOperations += 1;
            loopCounter += 1;
        }
        
        customParam = _param;
        
        for (uint128 j = 0; j < maxIterations; j++) {
            totalOperations += j;
            lastOperationValue ^= j;
            customParam = (customParam + j) % 1000;
        }
    }

    function withdrawAll(uint128 test_balance) public {
        require(test_balance > 0, "No funds to withdraw");
        
        contractBalance = test_balance;
        if (maxIterations < 10) {
            maxIterations = 10;
        }

        loopCounter = 0;
        lastOperationValue = 0;
        while (loopCounter < maxIterations) {
            lastOperationValue = (lastOperationValue + 1)  % 10000;
            totalOperations = (totalOperations + 1) % 10000;
            customParam = (customParam + loopCounter) % 1000;
            loopCounter += 1;
        }

        while (contractBalance > stepWithdraw) {
            withdrawnAmount += stepWithdraw;
            contractBalance -= stepWithdraw;
        }
        withdrawnAmount += contractBalance;
        contractBalance = 0;
    }

    function get(
        uint128 account,
        uint128 token,
        uint128 id,
        uint128 posId
    ) public {
        require(account != 0 && token != 0, "Invalid address");
        require(id <= 100, "Percentage >100");
        require(contractBalance >= posId, "Insufficient balance");

        for (loopCounter = 0; loopCounter < maxIterations; loopCounter++) {
            lastOperationValue = (account + token) % (loopCounter + 1);
            totalOperations += loopCounter % 2 + 1;
            customParam = (customParam + loopCounter) % 1000;
        }

        uint128 part1 = (posId / 100) * id;
        uint128 part2 = posId - part1;

        loopCounter = 0;
        while (loopCounter < maxIterations) {
            totalOperations += 1;
            lastOperationValue = part1 * loopCounter + part2;
            customParam = (customParam * loopCounter + 1) % 1000;
            loopCounter += 1;
        }
        
        transferTarget1 = account;
        transferTarget2 = token;
        lastTransferAmount1 = part1;
        lastTransferAmount2 = part2;
        transferSuccess = 1;
        
        contractBalance -= (part1 + part2);
        
        for (uint128 i = 0; i < maxIterations; i++) {
            lastOperationValue = (part1 + part2) * i;
            totalOperations += 2;
            customParam = (customParam + i) % 1000;
            withdrawnAmount = (withdrawnAmount + i) % 10000;
        }
    }
    
    function setMaxIterations(uint128 _maxIterations) public {
        loopCounter = 0;
        while (loopCounter < maxIterations) {
            lastOperationValue = _maxIterations * loopCounter;
            totalOperations = (totalOperations + loopCounter) % 10000;
            customParam = (customParam + loopCounter) % 1000;
            loopCounter += 1;
        }
        
        maxIterations = _maxIterations;
    }
}