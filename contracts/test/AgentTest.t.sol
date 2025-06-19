// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
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
    uint256 private signerPrivateKey;

    Agent.TradeData testTradeData;
    bytes32 constant DOMAIN_SEPARATOR_TYPEHASH =
        keccak256(
            "EIP712Domain(string name, string version, uint256 chainId, address verifyingContract)"
        );
    bytes32 constant TRADE_DATA_TYPEHASH =
        keccak256(
            "TradeData(address tokenIn, address tokenOut, uint256 amountIn, uint256 minAmountOut, uint256 maxAmountOut, uint256 deadline, uint256 nonce)"
        );

    function setUp() external {
        signerPrivateKey = 0xA11CE;
        authorizedSigner = vm.addr(signerPrivateKey);

        deployer = new DeployAgent();
        vm.deal(owner, INITIAL_BALANCE);
        (factory, agent) = deployer.run(authorizedSigner);

        testTradeData = Agent.TradeData({
            tokenIn: makeAddr("token1"),
            tokenOut: makeAddr("token2"),
            amountIn: 1 ether,
            minAmountOut: 0.9 ether,
            maxAmountOut: 1.1 ether,
            deadline: block.timestamp + 1 hours,
            nonce: 1
        });
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

    function testDomainSeparator() external view {
        bytes32 expectedDomainSeparator = keccak256(
            abi.encode(
                DOMAIN_SEPARATOR_TYPEHASH,
                keccak256(bytes("Agent")),
                keccak256(bytes("1")),
                block.chainid,
                address(agent)
            )
        );
        assertEq(agent.getDomainSeparator(), expectedDomainSeparator);
    }

    // function testExecuteSwapWithValidSignature() external {
    //     address token1 = makeAddr("token1");
    //     address token2 = makeAddr("token2");
    //     Agent.TradeData memory trade = Agent.TradeData({
    //         tokenIn: token1,
    //         tokenOut: token2,
    //         amountIn: 1,
    //         minAmountOut: 1,
    //         maxAmountOut: 2,
    //         deadline: block.timestamp + 1 hours,
    //         nonce: 1001
    //     });

    //     bytes memory sig = _signTradeData(trade, signerPrivateKey);

    //     vm.startPrank(authorizedSigner);
    //     agent.executeSwap(trade, sig);
    //     vm.stopPrank();
    // }

    function testExecuteSwapWithInvalidSignature() external {
        address token1 = makeAddr("token1");
        address token2 = makeAddr("token2");
        Agent.TradeData memory trade = Agent.TradeData({
            tokenIn: token1,
            tokenOut: token2,
            amountIn: 1,
            minAmountOut: 1,
            maxAmountOut: 2,
            deadline: block.timestamp + 1 hours,
            nonce: 1002
        });

        uint256 wrongKey = 0xB0B;
        bytes memory sig = _signTradeData(trade, wrongKey);

        vm.startPrank(authorizedSigner);
        vm.expectRevert(Agent.Agent__IncorrectSignature.selector);
        agent.executeSwap(trade, sig);
        vm.stopPrank();
    }

    function testExecuteSwapWithExpiredDeadline() external {
        address token1 = makeAddr("token1");
        address token2 = makeAddr("token2");
        Agent.TradeData memory trade = Agent.TradeData({
            tokenIn: token1,
            tokenOut: token2,
            amountIn: 1,
            minAmountOut: 1,
            maxAmountOut: 2,
            deadline: block.timestamp - 1,
            nonce: 1003
        });

        bytes memory sig = _signTradeData(trade, signerPrivateKey);

        vm.startPrank(authorizedSigner);
        vm.expectRevert(Agent.Agent__DeadlinePassed.selector);
        agent.executeSwap(trade, sig);
        vm.stopPrank();
    }

    function testExecuteSwapWithInvalidSignatureLength() external {
        address token1 = makeAddr("token1");
        address token2 = makeAddr("token2");
        Agent.TradeData memory trade = Agent.TradeData({
            tokenIn: token1,
            tokenOut: token2,
            amountIn: 1,
            minAmountOut: 1,
            maxAmountOut: 2,
            deadline: block.timestamp + 1 hours,
            nonce: 1004
        });

        bytes memory sig = new bytes(64);

        vm.startPrank(authorizedSigner);
        vm.expectRevert(Agent.Agent__IncorrectSignatureLength.selector);
        agent.executeSwap(trade, sig);
        vm.stopPrank();
    }

    // function testExecuteSwapWithUsedNonce() external {
    //     address token1 = makeAddr("token1");
    //     address token2 = makeAddr("token2");
    //     Agent.TradeData memory trade = Agent.TradeData({
    //         tokenIn: token1,
    //         tokenOut: token2,
    //         amountIn: 1,
    //         minAmountOut: 1,
    //         maxAmountOut: 2,
    //         deadline: block.timestamp + 1 hours,
    //         nonce: 1005
    //     });

    //     bytes memory sig = _signTradeData(trade, signerPrivateKey);

    //     vm.startPrank(authorizedSigner);
    //     agent.executeSwap(trade, sig);
    //     vm.expectRevert(Agent.Agent__NonceAlreadyUsed.selector);
    //     agent.executeSwap(trade, sig);
    //     vm.stopPrank();
    // }

    function testSignTradeDataProducesCorrectDigest() external {
        address token1 = makeAddr("token1");
        address token2 = makeAddr("token2");
        Agent.TradeData memory trade = Agent.TradeData({
            tokenIn: token1,
            tokenOut: token2,
            amountIn: 1,
            minAmountOut: 1,
            maxAmountOut: 2, 
            deadline: block.timestamp + 1 hours,
            nonce: 12345
        });

        bytes32 structHash = keccak256(
            abi.encode(
                TRADE_DATA_TYPEHASH,
                trade.tokenIn,
                trade.tokenOut,
                trade.amountIn,
                trade.minAmountOut,
                trade.maxAmountOut,
                trade.deadline,
                trade.nonce
            )
        );
        bytes32 digest = keccak256(
            abi.encodePacked("\x19\x01", agent.getDomainSeparator(), structHash)
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, digest);
        bytes memory expectedSignature = abi.encodePacked(r, s, v);

        bytes memory helperSignature = _signTradeData(trade, signerPrivateKey);

        assertEq(helperSignature, expectedSignature);
    }

    function _signTradeData(
        Agent.TradeData memory data,
        uint256 privateKey
    ) internal view returns (bytes memory) {
        bytes32 structHash = keccak256(
            abi.encode(
                TRADE_DATA_TYPEHASH,
                data.tokenIn,
                data.tokenOut,
                data.amountIn,
                data.minAmountOut,
                data.maxAmountOut,
                data.deadline,
                data.nonce
            )
        );
        bytes32 digest = keccak256(
            abi.encodePacked("\x19\x01", agent.getDomainSeparator(), structHash)
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
        return abi.encodePacked(r, s, v);
    }
}
