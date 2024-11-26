// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PrimeNumber {
    uint64 limit = 99991;
    uint64 limsqrt;
    uint64 parsqrt;
    uint64 idx;
    uint128 count1;
    uint128 count2;

    function isPrime() public returns (bool, uint128, uint128) {
        if (limit <= 1)
            return (false, 0, 0);

        // compute limsqrt = sqrt(limit)
        parsqrt = (limit + 1) / 2;
        limsqrt = limit;
        count1 = 0;
        while (parsqrt < limsqrt) {
            count1 = count1 + 1;
            limsqrt = parsqrt;
            parsqrt = (limit / parsqrt + parsqrt) / 2;
        }

        count2 = 0;
        for (idx = 2; idx <= limsqrt; idx++) {
            count2 = count2 + 1;
            if (limit % idx == 0)
                return (false, count1, count2);
        }
        return (true, count1, count2);
    }

    function setValues(uint64 val) public {
        limit = val;
    }

    function getValues() view public returns (uint64) {
        return limit;
    }

}

