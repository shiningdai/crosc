pragma solidity ^0.8.0;

contract CPUHeavy150 {
    // parameter list: 30, 50, 70, 90, 110, 130, 150
    uint SIZE = 150;
    uint lp;
    uint rp;
    uint md;

    function bubbleSort() public returns (uint){
        if (SIZE <= 1) {
            return 0;
        }
        uint[] memory data = new uint[](SIZE);
        for ( md = 0; md < SIZE; md++) {
            data[md] = SIZE-md;
        }

        for( lp = 0; lp < SIZE; lp++) {
            for(rp = 0; rp < SIZE - lp - 1; rp++) {
                if(data[rp] > data[rp + 1]) {
                    md = data[rp + 1];
                    data[rp + 1] = data[rp];
                    data[rp] = md;
                }
            }
        }

        return data[SIZE-1];
    }

    function getSize() public view returns (uint) {
        return SIZE;
    }

    function setSize(uint size) public {
        SIZE = size;
    }
}
