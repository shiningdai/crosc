pragma solidity >=0.0;

contract BaseSampleV3000 {
    // parameter list: 100, 500, 1000, 1500, 2000, 2500, 3000
    uint128 stat1 = 0;
    uint256 stat2 = 3000;
    uint128 stat3 = 0;
    
    function opVars() public returns(uint256){
        for (uint i = 0; i < stat2; i++){
            stat1 = stat1 + 1;
            stat3 = stat3 + 2;
        }
        stat2 = stat3 - stat1;
        return stat2;
    }
    
}