// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChainGame {
    // Player Info
    string public playerName = "Kitty";
    uint64 public playerLevel = 1;
    uint64 public playerExperience = 0;
    uint256 public playerBalance =100;

    // Experience required for upgrade  
    uint64 public levelUpExperience = 100;
    // Maximum experience obtainable per task  
    uint64 public maxExperienceIncrement = 100;
    // Minimum experience obtainable per task  
    uint64 public minExperienceIncrement = 10;
    uint64 experienceGained = 0;
    uint64 idx = 0;
    uint32 public taskCount = 0;


    event NewPlayer(address indexed playerAddress, string playerName);

    function createPlayer(string memory _name) public {
        require(bytes(playerName).length == 0, "Player already exists!");

        playerName = _name;
        playerLevel = 1;
        playerExperience = 0;
        playerBalance = 100;

        emit NewPlayer(msg.sender, _name);
    }

    // Complete the task and obtain the experience value  
    function completeTask(uint64 _baseExperience) public {
        require(taskCount >= 0);
        taskCount = taskCount + 1;

        // Calculate random experience value
        require(maxExperienceIncrement >= minExperienceIncrement);
        for (idx = 0; idx < 200; idx++) {
            experienceGained = (_baseExperience + idx) % maxExperienceIncrement + minExperienceIncrement;
            playerExperience += experienceGained;

            // Check if upgrade is possible  
            require(levelUpExperience > 0);
            if (playerExperience >= playerLevel * levelUpExperience) {
                playerLevel++;
                playerExperience = 0;
            }
        }

    }

    function getPlayerInfo() public view returns (string memory, uint64, uint64, uint256) {
        return (playerName, playerLevel, playerExperience, playerBalance);
    }
}
