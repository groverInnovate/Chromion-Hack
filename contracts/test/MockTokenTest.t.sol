// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {MockDAI} from "../src/mocks/MockDAI.sol";
import {MockWETH} from "../src/mocks/MockWETH.sol";
import {MockUSDT} from "../src/mocks/MockUSDT.sol";
import {DeployMocks} from "../script/DeployMocks.s.sol";

contract MockTokenTest is Test {
    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    MockUSDT usdt;
    MockDAI dai;
    MockWETH weth;
    DeployMocks deployer;
    address user = makeAddr("user");
    address recipient = makeAddr("recipient");

    function setUp() external {
        deployer = new DeployMocks();
        (dai, weth, usdt) = deployer.run();
    }

    /*//////////////////////////////////////////////////////////////
                            MOCKDAI TESTS
    //////////////////////////////////////////////////////////////*/
    function testDAIMintTransferAndBurn() external {
        uint256 mintAmount = 1000 ether;
        dai.mint(user, mintAmount);
        assertEq(dai.balanceOf(user), mintAmount);

        vm.startPrank(user);
        dai.transfer(recipient, 500 ether);
        vm.stopPrank();

        assertEq(dai.balanceOf(user), 500 ether);
        assertEq(dai.balanceOf(recipient), 500 ether);

        vm.startPrank(user);
        dai.burn(user, 200 ether);
        vm.stopPrank();

        assertEq(dai.balanceOf(user), 300 ether);
        assertEq(dai.totalSupply(), 800 ether);
    }

    function testDAITokenMetadata() external view {
        assertEq(dai.name(), "DAI");
        assertEq(dai.symbol(), "DAI");
        assertEq(dai.decimals(), 18);
    }

    /*//////////////////////////////////////////////////////////////
                            MOCKWETH TESTS
    //////////////////////////////////////////////////////////////*/
    function testWETHMintTransferAndBurn() external {
        uint256 mintAmount = 5 ether;
        weth.mint(user, mintAmount);
        assertEq(weth.balanceOf(user), mintAmount);

        vm.startPrank(user);
        weth.transfer(recipient, 2 ether);
        vm.stopPrank();

        assertEq(weth.balanceOf(user), 3 ether);
        assertEq(weth.balanceOf(recipient), 2 ether);

        vm.startPrank(user);
        weth.burn(user, 1 ether);
        vm.stopPrank();

        assertEq(weth.balanceOf(user), 2 ether);
        assertEq(weth.totalSupply(), 4 ether);
    }

    function testWETHTokenMetadata() external view {
        assertEq(weth.name(), "Wrapped ETH");
        assertEq(weth.symbol(), "WETH");
        assertEq(weth.decimals(), 18);
    }

    /*//////////////////////////////////////////////////////////////
                            MOCKUSDT TESTS
    //////////////////////////////////////////////////////////////*/
    function testUSDTMintTransferAndBurn() external {
        uint256 mintAmount = 5 ether;
        usdt.mint(user, mintAmount);
        assertEq(usdt.balanceOf(user), mintAmount);

        vm.startPrank(user);
        usdt.transfer(recipient, 2 ether);
        vm.stopPrank();

        assertEq(usdt.balanceOf(user), 3 ether);
        assertEq(usdt.balanceOf(recipient), 2 ether);

        vm.startPrank(user);
        usdt.burn(user, 1 ether);
        vm.stopPrank();

        assertEq(usdt.balanceOf(user), 2 ether);
        assertEq(usdt.totalSupply(), 4 ether);
    }

    function testUSDTTokenMetadata() external view {
        assertEq(usdt.name(), "USDT");
        assertEq(usdt.symbol(), "USDT");
        assertEq(usdt.decimals(), 18);
    }
}
