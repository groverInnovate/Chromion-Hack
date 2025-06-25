// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "../lib/forge-std/src/Script.sol";
import {MockDAI} from "../src/mocks/MockDAI.sol";
import {MockWETH} from "../src/mocks/MockWETH.sol";
import {MockUSDT} from "../src/mocks/MockUSDT.sol";

contract DeployMocks is Script {
    function run() external returns (MockDAI, MockWETH, MockUSDT) {
        vm.startBroadcast();
        MockDAI dai = new MockDAI();
        MockWETH weth = new MockWETH();
        MockUSDT usdt = new MockUSDT();
        vm.stopBroadcast();
        return (dai, weth, usdt);
    }
}
