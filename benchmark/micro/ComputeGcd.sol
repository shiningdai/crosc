// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ComputeGcd {
    uint64 num1 = 225851433717;
    uint64 num2 = 139583862445;
    uint64 count = 0;
    uint64 m = 0;

    function getGcd() public returns (uint64, uint64) {
        count = 0;
        while (num2 != 0) {
            count = count + 1;
            m = num2;
            num2 = num1 % num2;
            num1 = m;
        }
        return (num1, count);
    }

    function setNums(uint64 a, uint64 b) public {
        num1 = a;
        num2 = b;

    }

    function getNums() view public returns (uint64, uint64) {
        return (num1, num2);
    }

}
