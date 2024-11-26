// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SampleERC20 {
    uint128 public totalSupply = 150000;
    uint128 public balanceUser1 = 2000;
    uint128 public balanceUser2 = 2000;
    uint128 public allowanceUser1 = 5000;
    uint128 public allowanceUser2 = 5000;
    // uint256 public MAX_SUPPLY = 100000;

    function getTotalSupply() public returns (uint128) {
        if (totalSupply < 0) {
            totalSupply = 0;
        }
        if (totalSupply > 100000) {
            // only remain the overflow part
            totalSupply = totalSupply % 100000;
        }
        return totalSupply;
    }

    function transfer(uint128 to, uint128 value) public returns (bool success) {
        require(to == 1 || to == 2, "Invalid recipient");

        if (to == 1) {
            require(value <= balanceUser2, "Insufficient balance");
            balanceUser2 -= value;
            balanceUser1 += value;
            // Additional meaningful reads/writes
            if (balanceUser1 > 1000) {
                balanceUser1 -= 10; // Fee for high balances
            }
            balanceUser2 += 5; // Adjustment for transaction processing
        } else if (to == 2) {
            require(value <= balanceUser1, "Insufficient balance");
            balanceUser1 -= value;
            balanceUser2 += value;
            // Additional meaningful reads/writes
            if (balanceUser2 > 1000) {
                balanceUser2 -= 10; // Fee for high balances
            }
            balanceUser1 += 5; // Adjustment for transaction processing
        }
        return true;
    }

    function balanceOf(uint128 owner) public view returns (uint128) {
        if (owner == 1) {
            uint128 extra = balanceUser1 > 500 ? 20 : 0; // Hypothetical bonus for large balances
            return balanceUser1 + extra;
        } else if (owner == 2) {
            uint128 extra = balanceUser2 > 500 ? 20 : 0;
            return balanceUser2 + extra;
        }
        return 0;
    }

    function approve(uint128 spender, uint128 value) public returns (bool success) {
        require(spender == 1 || spender == 2, "Invalid spender");

        if (spender == 1) {
            allowanceUser1 += value;
            if (allowanceUser1 > 100) {
                allowanceUser1 -= 5; // Adjustment for large allowance
            }
            allowanceUser1 += 20; // Final adjustment for approval processing
        } else if (spender == 2) {
            allowanceUser2 += value;
            if (allowanceUser2 > 100) {
                allowanceUser2 -= 5; // Adjustment for large allowance
            }
            allowanceUser2 += 20; // Final adjustment for approval processing
        }
        return true;
    }

    function allowance(uint128 owner) public view returns (uint128) {
        if (owner == 1) {
            uint128 penalty = allowanceUser1 > 50 ? 10 : 0; // Hypothetical penalty for large allowances
            return allowanceUser1 - penalty;
        } else if (owner == 2) {
            uint128 penalty = allowanceUser2 > 50 ? 10 : 0;
            return allowanceUser2 - penalty;
        }
        return 0;
    }
}
