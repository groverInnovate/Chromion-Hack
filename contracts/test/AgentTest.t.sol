// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {AgentFactory} from "../src/AgentFactory.sol";
import {Agent} from "../src/Agent.sol";
import {DeployAgent} from "../script/DeployAgent.s.sol";
import {Platform} from "../src/PlatformType.sol";

contract AgentTest is Test {
    AgentFactory public factory;
    Agent public agent;
    DeployAgent public deployer;
    address public authorizedSigner = makeAddr("authorizedSigner");
    address public owner = makeAddr("owner");
    uint256 public constant INITIAL_BALANCE = 10 ether;

    function setUp() external {
        deployer = new DeployAgent();
        vm.deal(owner, INITIAL_BALANCE);
        (factory, agent) = deployer.run();
    }

    function testCreatedAgent() external {
        (
            address agentAddress,
            address _owner,
            address[] memory __tokens,
            uint256 amount,
            Platform platform
        ) = factory.getAgentInfo(owner, 0);
        assertEq(agentAddress, address(agent));
        assertEq(_owner, owner);
        assertEq(__tokens.length, 3);
        assertEq(__tokens[0], makeAddr("token0"));
        assertEq(__tokens[1], makeAddr("token1"));
        assertEq(__tokens[2], makeAddr("token2"));
        assertEq(amount, 1 ether);
        assertEq(uint256(platform), uint256(Platform.Twitter));
    }

    function testCreateMultipleAgentsWithDifferentPlatformsAndTokens()
        external
    {
        address[] memory newTokens = new address[](2);
        address[] memory newTokenAgain = new address[](1);
        newTokens[0] = makeAddr("newToken0");
        newTokens[1] = makeAddr("newToken1");
        newTokenAgain[0] = makeAddr("newToken");
        vm.startPrank(owner);
        Agent newAgent = factory.createAgent{value: 2 ether}(
            newTokens,
            Platform.Discord,
            authorizedSigner
        );
        Agent newAgentAgain = factory.createAgent{value: 3 ether}(
            newTokenAgain,
            Platform.Telegram,
            authorizedSigner
        );
        (
            address agentAddressNew,
            address _ownerNew,
            address[] memory __tokensNew,
            uint256 amountNew,
            Platform platformNew
        ) = factory.getAgentInfo(owner, 1);
        (
            address agentAddressNewAgain,
            address _ownerNewAgain,
            address[] memory __tokensNewAgain,
            uint256 amountNewAgain,
            Platform platformNewAgain
        ) = factory.getAgentInfo(owner, 2);
        vm.stopPrank();
        assertEq(agentAddressNew, address(newAgent));
        assertEq(_ownerNew, owner);
        assertEq(__tokensNew.length, 2);
        assertEq(__tokensNew[0], makeAddr("newToken0"));
        assertEq(__tokensNew[1], makeAddr("newToken1"));
        assertEq(amountNew, 2 ether);
        assertEq(uint256(platformNew), uint256(Platform.Discord));
        assertEq(agentAddressNewAgain, address(newAgentAgain));
        assertEq(_ownerNewAgain, owner);
        assertEq(__tokensNewAgain.length, 1);
        assertEq(__tokensNewAgain[0], makeAddr("newToken"));
        assertEq(amountNewAgain, 3 ether);
        assertEq(uint256(platformNewAgain), uint256(Platform.Telegram));
    }

    function testPauseAndResumeAgent() external {
        vm.startPrank(owner);
        agent.pauseAgent();
        assertEq(agent.isPaused(), true);

        agent.resumeAgent();
        assertEq(agent.isPaused(), false);
        vm.stopPrank();
    }

    function testOnlyOwnerCanPauseAgent() external {
        address random = makeAddr("random");
        vm.startPrank(random);
        vm.expectRevert();
        agent.pauseAgent();
        vm.stopPrank();
    }

    function testOnlyOwnerCanResumeAgent() external {
        address random = makeAddr("random");
        vm.startPrank(random);
        vm.expectRevert();
        agent.resumeAgent();
        vm.stopPrank();
    }

    function testCannotWithdrawFundsWhileRunning() external {
        vm.startPrank(owner);
        vm.expectRevert();
        agent.withdrawFunds();
        vm.stopPrank();
    }

    function testWithdrawFunds() external {
        uint256 userInitialBalance = owner.balance;
        uint256 agentInitialBalance = address(agent).balance;
        vm.startPrank(owner);
        agent.pauseAgent();
        agent.withdrawFunds();
        vm.stopPrank();
        uint256 userFinalBalance = owner.balance;
        uint256 agentFinalBalance = address(agent).balance;
        assertEq(
            userFinalBalance - userInitialBalance,
            agentInitialBalance - agentFinalBalance
        );
    }
}
