// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Agent} from './Agent.sol';

contract AgentFactory {

    uint256 constant public MAX_AGENTS_LIMIT = 3; // one for each platform

    error Factory__NoTokenPresent();
    error Factory__PlatformNotAvailable();
    error Factory__AmountIsZero();

    event Factory__AgentCreated();

    enum PlatformType {
        Twitter,
        Telegram,
        Discord
    }

    struct AgentInfo {
        address agentAddress;
        address owner;
        string[] tokens;
        uint256 createdAt;
        uint256 amountInvested;
        string PlatformType;
    }

    mapping (address user => AgentInfo[]) userToAgents;
    mapping (address user => uint256 number) userToNumberOfAgents;

    function createAgent(string[] memory _tokens, string memory _platformType) external payable {
        if (_tokens.length == 0) {
            revert Factory__NoTokenPresent();
        }
        if (keccak256(bytes(_platformType)) != keccak256(bytes("Telegram")) && 
            keccak256(bytes(_platformType)) != keccak256(bytes("Twitter")) && 
            keccak256(bytes(_platformType)) != keccak256(bytes("Discord"))) {
            revert Factory__PlatformNotAvailable();
        }
        if (msg.value <= 0) {
            revert Factory__AmountIsZero();
        }

        Agent agent = new Agent{value: msg.value}(_tokens, _platformType);

        AgentInfo memory info = AgentInfo({
            agentAddress: address(agent),
            owner: msg.sender,
            tokens: _tokens,
            createdAt: block.timestamp,
            amountInvested: msg.value,
            PlatformType: _platformType
        });

        userToAgents[msg.sender].push(info);
        userToNumberOfAgents[msg.sender] += 1;
        emit Factory__AgentCreated();
    }   

    function getNumberofAgentsForUser(address user) external view returns(uint256) {
        return userToNumberOfAgents[user];
    }

    function getAgentsForUser(address user) external view returns(AgentInfo[] memory) {
        return userToAgents[user];
    }
}