// SPDX-License-Identifier:MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";

/**
 * @title CTF - CollectReward.
 * @notice This is a rewards program.
 * In this the user gets a reward based on a timestamp and block.
 * You need to find a start time to collect the reward.
 * */
contract CollectReward {
    uint256 public constant ONE_DAY = 86400;
    uint256 public constant MULTIPLIER = 2;

    uint256 public maxDuration;
    uint256 public programStartTime;
    uint256 public deploymentBlock;
    mapping(uint256 => uint256) public blockDetails;

    constructor() payable {
        programStartTime = block.timestamp;
        maxDuration = 3 * ONE_DAY;
        deploymentBlock = block.number;
        _setBlocks(programStartTime, programStartTime + (9 * ONE_DAY));
    }

    function collect(uint256 _startTime) external payable {
        require(msg.value == 1 ether);

        console.log("--------------------------------------------------");

        (uint256 withdrawTime, uint256 amount) = _getReward(_startTime);

        console.log("--------------------------------------------------");
        console.log("WITHDRAW TIME", withdrawTime);
        console.log("AMOUNT", amount);

        require(withdrawTime > 0 && amount > 0, "no valid reward");
        // Send all ether to user
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "send fail");
    }

    function _getReward(uint256 _startTime)
        internal
        view
        returns (uint256 withdrawTime, uint256 amount)
    {
        uint256 reward;
        uint256 currentTime = programStartTime + (8 * ONE_DAY) + 43200;
        uint256 lastInterval = _calculateTimestamp(currentTime);

        withdrawTime = programStartTime;

        console.log("WITHDRAW TIME", withdrawTime);
        console.log("CURRENT TIME", currentTime);
        console.log("LAST INTERVAL", lastInterval);
        console.log("IF", lastInterval <= withdrawTime);

        if (lastInterval <= withdrawTime) return (0, 0);

        console.log("--------------------------------------------------");

        if (_startTime > 0) {
            uint256 latestStartTime = _calculateTimestamp(_startTime);
            console.log("LATEST START TIME", latestStartTime);
            withdrawTime = latestStartTime;
        }

        console.log("--------------------------------------------------");

        uint256 newMaxDuration = withdrawTime + maxDuration;

        console.log("NEW MAX DURATION", newMaxDuration);
        console.log("DURATION IF", newMaxDuration < currentTime);

        uint256 duration = newMaxDuration < currentTime
            ? _calculateTimestamp(newMaxDuration)
            : lastInterval;

        console.log("DURATION", duration);

        for (uint256 i = withdrawTime; i < duration; i += ONE_DAY) {
            console.log("FOR NUMERO", i);
            uint256 referenceBlock = blockDetails[i];
            reward = reward + _computeReward(referenceBlock, i);
        }

        console.log("REWARD", reward);

        withdrawTime = duration;
        amount = reward * MULTIPLIER;
    }

    function _computeReward(uint256 _block, uint256 _date)
        internal
        view
        returns (uint256 reward)
    {
        console.log("--------------------------------------------------");
        console.log("REFERENCE BLOCK", _block);
        console.log("DEPLOYMENT BLOCK", deploymentBlock);
        console.log("IF BLOCK", _block > deploymentBlock);
        console.log("DATE", _date);
        console.log("PST", programStartTime + 518400);
        console.log("IF DATE", _date == programStartTime + 518400);
        if (_block > deploymentBlock && _date == programStartTime + 518400) {
            reward = _block + _date;
        }
    }

    function _calculateTimestamp(uint256 timestamp)
        internal
        view
        returns (uint256 validTimeStamp)
    {
        require(timestamp >= programStartTime, "invalid timestamp");
        uint256 period = (timestamp - programStartTime) / ONE_DAY;
        validTimeStamp = period * ONE_DAY + programStartTime;
    }

    function _setBlocks(uint256 _startTime, uint256 _endTime) internal {
        uint8 k;
        for (uint256 i = _startTime; i <= _endTime; i += ONE_DAY) {
            uint256 checkpointBlock = deploymentBlock + (k * 5760);
            blockDetails[i] = checkpointBlock;
            k++;
        }
    }

    function getProgramStartTime() external view returns (uint256) {
        return programStartTime;
    }
}
