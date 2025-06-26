// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/*//////////////////////////////////////////////////////////////
                            IMPORTS
//////////////////////////////////////////////////////////////*/
import {Script} from "../lib/forge-std/src/Script.sol";
import {MockDAI} from "../src/mocks/MockDAI.sol";
import {MockWETH} from "../src/mocks/MockWETH.sol";
import {MockUSDT} from "../src/mocks/MockUSDT.sol";

contract DeployMocks is Script {
    /*//////////////////////////////////////////////////////////////
                              FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function run() external returns (MockDAI, MockWETH, MockUSDT) {
        MockDAI dai = new MockDAI();
        MockWETH weth = new MockWETH();
        MockUSDT usdt = new MockUSDT();
        return (dai, weth, usdt);
    }
}
