// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "../lib/forge-std/src/Script.sol";
import {AgentFactory} from "../src/AgentFactory.sol";
import {Agent} from "../src/Agent.sol";
import {Platform} from "../src/PlatformType.sol";

contract DeployAgent is Script {
    /*//////////////////////////////////////////////////////////////
                           STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    address owner = makeAddr("owner");
    uint256 constant INITIAL_BALANCE = 10 ether;

    /*//////////////////////////////////////////////////////////////
                                FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function run(
        address authorizedSigner
    ) external returns (AgentFactory, Agent) {
        vm.deal(owner, INITIAL_BALANCE);
        vm.startBroadcast(owner);
        AgentFactory factory = new AgentFactory();
        address[] memory tokenArray = new address[](3);
        tokenArray[0] = makeAddr("token0");
        tokenArray[1] = makeAddr("token1");
        tokenArray[2] = makeAddr("token2");
        Agent agent = factory.createAgent{value: 1 ether}(
            tokenArray,
            Platform.Twitter,
            authorizedSigner
        );
        vm.stopBroadcast();
        return (factory, agent);
    }
}
