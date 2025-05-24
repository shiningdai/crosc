// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HoloToken {
  uint32 public totalSupply = 300000000;
  
  uint32 public balance0 = 150000000;
  uint32 public balance1 = 150000000;
  
  uint32 public allowance0to1 = 5000;
  uint32 public allowance1to0 = 5000;
  
  function balanceOf(uint32 accountId) public view returns (uint32) {
    if (accountId == 0) return balance0;
    return balance1;
  }
  
  function transfer(uint32 from, uint32 to, uint32 value) public returns (bool) {
    if (from == 0 && to == 1) {
      if (value <= balance0) {
        for (uint i = 0; i < value; i++) {
          balance0 = balance0 - 1;
          balance1 = balance1 + 1;
        }
        return true;
      }
    } else if (from == 1 && to == 0) {
      if (value <= balance1) {
        for (uint i = 0; i < value; i++) {
          balance0 = balance0 + 1;
          balance1 = balance1 - 1;
        }
        return true;
      }
    }
    return false;
  }
  
  function approve(uint32 from, uint32 to, uint32 value) public returns (bool) {
    if (from == 0 && to == 1) {
      allowance0to1 = value;
      return true;
    } else if (from == 1 && to == 0) {
      allowance1to0 = value;
      return true;
    }
    return false;
  }
  
  function transferFrom(uint32 from, uint32 to, uint32 value) public returns (bool) {
    if (from == 0 && to == 1) {
      if (value <= balance0 && value <= allowance0to1) {
        for (uint i = 0; i < value; i++) {
          balance0 = balance0 - 1;
          balance1 = balance1 + 1;
          allowance0to1 = allowance0to1 - 1;
        }
        return true;
      }
    } else if (from == 1 && to == 0) {
      if (value <= balance1 && value <= allowance1to0) {
        for (uint i = 0; i < value; i++) {
          balance1 = balance1 - 1;
          balance0 = balance0 + 1;
          allowance1to0 = allowance1to0 - 1;
        }
          
        return true;
      }
    }
    return false;
  }
  
  function adjustAllowance(uint32 from, uint32 to, uint32 value, uint32 isIncrease) public returns (bool) {
    if (from == 0 && to == 1) {
      if (isIncrease == 1) {
        for (uint i = 0; i < value; i++) {
          allowance0to1 = allowance0to1 + 1;
        }
      } else {
        if (value > allowance0to1) {
          allowance0to1 = 0;
        } else {
          for (uint i = 0; i < value; i++) {
            allowance0to1 = allowance0to1 - 1;
          }
        }
      }
      return true;
    }
    else if (from == 1 && to == 0){
      if (isIncrease == 1) {
        for (uint i = 0; i < value; i++) {
          allowance1to0 = allowance1to0 + 1;
        }
      } else {
        if (value > allowance1to0) {
          allowance1to0 = 0;
        } else {
          for (uint i = 0; i < value; i++) {
            allowance1to0 = allowance1to0 - 1;
          }
        }
      }
      return true;
    }
    return false;
  }
}