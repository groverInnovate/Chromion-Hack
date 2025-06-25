// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Agent} from "./Agent.sol";
import {Platform} from "./PlatformType.sol";

contract AgentFactory {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/
    error Factory__NoTokenPresent();
    error Factory__PlatformNotAvailable();
    error Factory__AmountIsZero();

    /*//////////////////////////////////////////////////////////////
                             TYPE VARIABLES
    //////////////////////////////////////////////////////////////*/
    struct AgentInfo {
        address agentAddress;
        address owner;
        address[] tokens;
        uint256 amountInvested;
        Platform platformType;
    }

    /*//////////////////////////////////////////////////////////////
                                MAPPING
    //////////////////////////////////////////////////////////////*/
    mapping(address user => AgentInfo[]) public userToAgents;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    event Factory__AgentCreated(
        address indexed agentAddress,
        Platform indexed platform,
        address[] indexed tokens
    );

    /*//////////////////////////////////////////////////////////////
                                FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                           EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function createAgent(
        address[] memory _tokens,
        Platform _platformType,
        address authorizedSigner // address of the psuedo wallet created for the backend which will execute the swap function
    ) external payable returns (Agent) {
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
        emit Factory__AgentCreated(address(agent), _platformType, _tokens);
        return agent;
    }

    /*//////////////////////////////////////////////////////////////
                           INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function isValidPlatform(Platform platform) internal pure returns (bool) {
        return (platform == Platform.Telegram ||
            platform == Platform.Twitter ||
            platform == Platform.Discord);
    }

    /*//////////////////////////////////////////////////////////////
                           GETTER FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function getAgentInfo(
        address user,
        uint256 index
    ) external view returns (AgentInfo memory) {
        AgentInfo storage info = userToAgents[user][index];
        return
            AgentInfo(
                info.agentAddress,
                info.owner,
                info.tokens,
                info.amountInvested,
                info.platformType
            );
    }
}
