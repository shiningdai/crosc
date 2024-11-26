// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    // Product status constant   
    // uint constant STATE_CREATED = 0;
    // uint constant STATE_IN_TRANSIT = 1;
    // uint constant STATE_DELIVERED = 2;

    // Product Info
    uint64 public productId=0;             // Current product ID    
    uint64 public manufacturerId=0;        // Manufacturer ID 
    uint64 public currentOwnerId=0;        // Current owner ID
    uint128 public productNameHash=0;       // Product name hash value 
    uint128 public state=0;                 // Product status  
    uint128 public timestamp=0;          // Status update time  
    uint128 public previousTimestamp=0;  // Timestamp before status update  
    uint128 public locationHash=0;          // Product location history hash value
    uint128 public idx;

    event ProductStateUpdated(uint128 productId, uint128 newState, uint64 updatedBy);

    function createProduct(uint128 _nameHash, uint128 _initialLocationHash, uint64 manuID) public {
        productId++;
        productNameHash = _nameHash;
        manufacturerId = manuID;
        currentOwnerId = manufacturerId;
        state = 0;
        timestamp = 0;
        locationHash = _initialLocationHash;

        emit ProductStateUpdated(productId, state, manufacturerId);
    }


    // Function for updating the status and location of the product  
    function updateState(uint128 _newState, uint128 _newLocationHash) public {
        // Update timestamp  
        previousTimestamp = timestamp;
        timestamp += 1;

        if (state != _newState) {
            locationHash = (_newLocationHash + previousTimestamp) % 10000;
            state = _newState;
        }

        for (idx = 1; idx <= 500; idx++) {
            locationHash = (locationHash + timestamp + idx) % 10000 + state;
        }
    }

    function getProduct() public view returns (uint64, uint128, uint64, uint64, uint128, uint128, uint128) {
        return (productId, productNameHash, manufacturerId, currentOwnerId, state, timestamp, locationHash);
    }
}
