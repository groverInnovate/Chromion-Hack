// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Agent} from "./Agent.sol";

/// @title AgentFactory Contract
/// @notice Factory contract for creating and managing trading agents
/// @dev Creates new Agent instances and maintains a registry of all created agents
contract AgentFactory {
    error Factory__NoTokenPresent();
    error Factory__PlatformNotAvailable();
    error Factory__AmountIsZero();

    /// @notice Structure to store information about created agents
    /// @param agentAddress The address of the created agent contract
    /// @param owner The address of the agent owner
    /// @param tokens Array of token addresses supported by the agent
    /// @param amountInvested Initial investment amount in wei
    /// @param platformType The platform type associated with the agent
    struct AgentInfo {
        address agentAddress;
        address owner;
        address[] tokens;
        uint256 amountInvested;
        Agent.PlatformType platformType;
    }

    /// @notice Mapping of user addresses to their created agents
    mapping(address => AgentInfo[]) public userToAgents;

    /// @notice Event emitted when a new agent is created
    /// @param agentAddress The address of the newly created agent
    /// @param platform The platform type associated with the agent
    event Factory__AgentCreated(
        address indexed agentAddress,
        Agent.PlatformType indexed platform
    );

    /// @notice Creates a new trading agent
    /// @param _tokens Array of token addresses that the agent will support
    /// @param _platformType The platform type for the agent (Twitter, Telegram, or Discord)
    /// @param authorizedSigner Address that will be authorized to execute trades
    /// @dev Requires a non-zero ETH value to be sent with the transaction
    function createAgent(
        address[] memory _tokens,
        Agent.PlatformType _platformType,
        address authorizedSigner // address of the psuedo wallet created for the backend which will execute the swap function
    ) external payable {
        if (_tokens.length == 0) {
            revert Factory__NoTokenPresent();
        }
        if (!isValidPlatform(_platformType)) {
            revert Factory__PlatformNotAvailable();
        }
        if (msg.value <= 0) {
            revert Factory__AmountIsZero();
        }

        Agent agent = new Agent{value: msg.value}(
            _tokens,
            _platformType,
            authorizedSigner,
            msg.sender
        );

        AgentInfo memory info = AgentInfo({
            agentAddress: address(agent),
            owner: msg.sender,
            tokens: _tokens,
            amountInvested: msg.value,
            platformType: _platformType
        });

        userToAgents[msg.sender].push(info);
        emit Factory__AgentCreated(msg.sender, _platformType);
    }

    /// @notice Internal function to validate platform type
    /// @param platform The platform type to validate
    /// @return bool True if the platform is valid, false otherwise
    function isValidPlatform(
        Agent.PlatformType platform
    ) internal pure returns (bool) {
        return (platform == Agent.PlatformType.Telegram ||
            platform == Agent.PlatformType.Twitter ||
            platform == Agent.PlatformType.Discord);
    }
}
