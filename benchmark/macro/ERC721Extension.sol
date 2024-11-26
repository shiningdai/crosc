// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC721Extension {
    uint128 public totalTokens = 100000;
    uint128 public ownerToken1 = 1000;
    uint128 public ownerToken2 = 1000;
    uint128 public approvalForTransfer;
    uint128 public mintUnit = 100;
    uint128 public transRecord;
    uint128 public loopCount;
    uint128 public idx;

    function approve(uint128 spender) public returns (uint128, uint128) {
        // require(spender == 1 || spender == 2, "Invalid spender");
        // Loop to modify approvalForTransfer
        approvalForTransfer = 0;
        loopCount = 0;
        if (spender == 1) {
            // Reserve a certain handling fee
            ownerToken1 = ownerToken1 - 10;
            for (idx = 0; idx < ownerToken1; idx += 10) {
                loopCount = loopCount + 1;
                approvalForTransfer += 10;
            }
            ownerToken1 = ownerToken1 + 10;
        } else if (spender == 2) {
            ownerToken2 = ownerToken2 - 10;
            for (idx = 0; idx < ownerToken2; idx += 10) {
                loopCount = loopCount + 1;
                approvalForTransfer += 10;
            }
            ownerToken2 = ownerToken2 + 10;
        }
        
        return (approvalForTransfer, loopCount);
    }

    function allowance() public view returns (uint128) {
        return approvalForTransfer;
    }

    
    function balanceOf(uint128 owner) public view returns (uint128) {
        if (owner == 1)
            return ownerToken1;
        return ownerToken2;
    }

    function mintToken(uint128 owner) public returns (uint128) {
        // require(totalTokens < maxTokens, "Max tokens reached");
        // Loop to increment totalTokens and assign to ownerToken based on owner ID
        loopCount = 0;
        if (owner == 1) {
            for (idx = 0; idx < mintUnit; idx++) {
                loopCount = loopCount + 1;
                totalTokens = totalTokens + 1;
                ownerToken1 = ownerToken1 + 1;
                    
            } 
        } else if (owner == 2) {
            for (idx = 0; idx < mintUnit; idx++) {
                loopCount = loopCount + 1;
                totalTokens = totalTokens + 1;
                ownerToken2 = ownerToken2 + 1;
            } 
        }
        return loopCount;
    }

    function transferToken(uint128 fromOwner, uint128 value) public returns (uint128, uint128) {
        // Loop to decrease fromOwner's tokens and increase toOwner's tokens
        transRecord = value;
        if (fromOwner == 1 && ownerToken1 > transRecord) {
            loopCount = 0;
            for (idx = 0; idx < transRecord; idx++) {
                loopCount = loopCount + 1;
                ownerToken1 = ownerToken1 - 1;
                ownerToken2 = ownerToken2 + 1;
            }  
        } else if (fromOwner == 2 && ownerToken2 > transRecord) {
            loopCount = 0;
            for (idx = 0; idx < transRecord; idx++) {
                loopCount = loopCount + 1;
                ownerToken2 = ownerToken2 - 1;
                ownerToken1 = ownerToken1 + 1;
            } 
        }
        return (transRecord, loopCount);
    }
}
