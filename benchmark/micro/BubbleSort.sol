// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BubbleSort {
    uint128 SIZE = 150;
    uint128 md;
    uint64 count;
    uint32 lp;
    uint32 rp;

    function bSort() public returns (uint128, uint64){
        if (SIZE <= 1) {
            return (0, 0);
        }
        uint128[] memory data = new uint128[](SIZE);
        for ( md = 0; md < SIZE; md++) {
            data[md] = SIZE-md;
        }
        count = 0;
        for( lp = 0; lp < SIZE; lp++) {
            for(rp = 0; rp < SIZE - lp - 1; rp++) {
                count = count + 1;
                if(data[rp] > data[rp + 1]) {
                    md = data[rp + 1];
                    data[rp + 1] = data[rp];
                    data[rp] = md;
                }
            }
        }

        return (data[SIZE-1], count);
    }

    function getSize() public view returns (uint128) {
        return SIZE;
    }

    function setSize(uint128 size) public {
        SIZE = size;
    }
}
