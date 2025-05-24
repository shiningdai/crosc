// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FakeAirdrop {
    uint128 public ownerID = 1;
    uint128 public balance = 1000;
    uint128 public claimAmount = 0;
    uint128 public stepClaim = 0;
    uint128 public maxClaims = 100;
    uint128 public totalClaimed = 0;
    uint128 public claimLimit = 10;
    uint128 public userCount = 0;
    uint128 public processingFee = 10000;
    uint128 public currClaimAmount = 0;
    
    function claim() public {
        uint128 tempBalance = balance;
        uint128 iterations = 0;
        
        while (iterations < claimLimit && tempBalance >= claimAmount) {
            tempBalance = tempBalance - claimAmount;
            totalClaimed = totalClaimed + 1;
            iterations = iterations + 1;
        }
        
        balance = tempBalance;
        userCount = userCount + 1;
    }
    
    function deposit(uint128 amount) public {
        uint128 tempAmount = amount;
        uint128 i = 0;
        
        while (i < 5) {
            tempAmount = tempAmount - processingFee;
            i = i + 1;
        }
        
        balance = balance + tempAmount;
    }
    
    function drain(uint128 claims) public {
        currClaimAmount = claims;
        stepClaim = 0;

        while (stepClaim <= currClaimAmount && processingFee > 10) {
            totalClaimed = totalClaimed + 10;
            stepClaim += 10;
            processingFee = processingFee - 1;
        }
        if (processingFee < 1000) {
            processingFee = processingFee + 1000;
            balance = balance - 100;
        }
        
        totalClaimed = totalClaimed + currClaimAmount - stepClaim;
    }
}