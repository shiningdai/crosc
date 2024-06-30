pragma solidity ^0.8.0;

contract FibonacciV350 {
    // parameter list: 50, 100, 150, 200, 250, 300, 350
    uint num = 350;
    uint result = 0;
    uint idx = 0;
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
