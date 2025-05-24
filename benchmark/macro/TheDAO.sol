// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TheDAO {
    uint128 public proposalCount = 1;     // Proposal count  
    uint128 public totalShares = 1000;       // Total shares  
    uint128 public sharesUser1 = 300;       // Shares of user 1  
    uint128 public sharesUser2 = 700;       // Shares of user 2  
    uint128 public votesFor = 0;          // Current count of affirmative votes  
    uint128 public votesAgainst = 0;      // Current count of opposing votes  
    uint128 public currentProposal = 0;   // Current proposal ID  
    bool public executed = false;             // Whether the proposal is executed
    uint128 shares;
    uint128 idx;


    event ProposalCreated(uint256 id);
    event Voted(uint256 id, uint32 support);

    function createProposal() external {
        proposalCount++;
        currentProposal = proposalCount;
        votesFor = 0;
        votesAgainst = 0;
        executed = false;
        emit ProposalCreated(currentProposal);
    }

    function setShares(uint128 user, uint128 value) external {
        if (user == 1) {
            sharesUser1 = value;
        } else if (user == 2) {
            sharesUser2 = value;
        }
        totalShares += value;
    }

    // support: willingness to support (from 1 to 10)
    // >5 indicates support; <=5 indicates opposition. 
    function vote(uint32 support) public {
        shares = (support > 5) ? sharesUser1 : sharesUser2;
        require(shares > 0, "No shares to vote with");
        require(!executed, "Proposal already executed");
        require(totalShares > 0, "Invalid total shares");

        for (idx = 0; idx < shares; idx++) {
            if (support > 5) {
                votesFor++;
            } else {
                votesAgainst++;
            }
            if (votesFor + votesAgainst >= totalShares) {
                totalShares = votesFor + votesAgainst;
                break;
            }
        }

        emit Voted(currentProposal, support);
    }

    function executeProposal() external {
        require(!executed, "Proposal already executed");
        require(votesFor > votesAgainst, "Proposal not passed");

        executed = true;
        // Specific logic for executing the proposal can be added here
    }
}
