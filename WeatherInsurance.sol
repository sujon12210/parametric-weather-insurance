// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/**
 * @title WeatherInsurance
 * @dev Automatic payouts based on rainfall data.
 */
contract WeatherInsurance is ReentrancyGuard, Ownable {
    AggregatorV3Interface internal rainfallFeed;
    
    struct Policy {
        address farmer;
        uint256 premium;
        uint256 payoutAmount;
        int256 rainfallThreshold;
        bool isActive;
        bool claimed;
    }

    mapping(uint256 => Policy) public policies;
    uint256 public policyCount;

    event PolicyCreated(uint256 indexed id, address indexed farmer);
    event InsurancePaid(uint256 indexed id, address indexed farmer, uint256 amount);

    constructor(address _oracleAddress) Ownable(msg.sender) {
        rainfallFeed = AggregatorV3Interface(_oracleAddress);
    }

    function buyPolicy(uint256 _payout, int256 _threshold) external payable {
        require(msg.value == _payout / 10, "Premium must be 10% of payout");
        
        policies[policyCount] = Policy({
            farmer: msg.sender,
            premium: msg.value,
            payoutAmount: _payout,
            rainfallThreshold: _threshold,
            isActive: true,
            claimed: false
        });

        emit PolicyCreated(policyCount++, msg.sender);
    }

    /**
     * @dev Checks weather data and triggers payout if threshold is met.
     */
    function triggerClaim(uint256 _policyId) external nonReentrant {
        Policy storage policy = policies[_policyId];
        require(policy.isActive && !policy.claimed, "Policy not valid");

        (, int256 currentRainfall, , , ) = rainfallFeed.latestRoundData();

        if (currentRainfall < policy.rainfallThreshold) {
            policy.claimed = true;
            policy.isActive = false;
            payable(policy.farmer).transfer(policy.payoutAmount);
            emit InsurancePaid(_policyId, policy.farmer, policy.payoutAmount);
        }
    }
}
