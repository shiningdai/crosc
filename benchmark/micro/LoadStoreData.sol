// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LoadStoreData {
    uint SIZE = 2000;
    uint idx = 0;
    uint8 ui1 = 0;
    uint u1 = 0;
    uint16 ui2 = 0;
    uint u2 = 0;
    uint32 ui4 = 0;
    uint u3 = 0;
    uint64 ui8 = 0;
    uint u4 = 0;
    uint128 ui16 = 0;

    function rwData() public returns (uint128) {
        if (SIZE <= 1) {
            return 0;
        }
        for ( idx = 0; idx < SIZE; idx += 1) {
            if ( idx < 255 ) {
                ui1 = ui1 + 1;
                u1 = u1 + 1;
            }
            if ( idx < 32767 ) {
                ui2 = ui2 + 2;
                u2 = u2 + 2;
            }
            ui4 = ui4 + 3;
            u3 = u3 + 3;
            ui8 = ui8 + 4;
            u4 = u4 + 4;
            ui8 = ui8 + 4;
            u4 = u4 + 4;
            ui16 = ui16 + 5;
        }

        return ui16;
    }
}
