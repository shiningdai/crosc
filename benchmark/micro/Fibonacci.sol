// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fibonacci {
    uint32 num = 300;
    uint32 idx = 0;
    uint result = 0;
    uint fib1 = 0;
    uint fib2 = 0;

    function fibonacci() public returns (uint) {
        fib1 = 0;
        fib2 = 1;
        if (num == 0) {
            result = 0;
            return fib1;
        }
        for (idx = 2; idx <= num; idx++) {
            result = fib1 + fib2;
            fib1 = fib2;
            fib2 = result;
        }
        return result;
    }
    
    function getResult() view public returns (uint) {
        return result;
    }

}
