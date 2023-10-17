// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {WETH} from "../../src/WETH.sol";

// https://book.getfoundry.sh/forge/invariant-testing?highlight=targetSelector#invariant-targets
// https://mirror.xyz/horsefacts.eth/Jex2YVaO65dda6zEyfM_-DXlXhOWCAoSpOx5PLocYgw

// NOTE: open testing - randomly call all public functions
// つまりWethコントラクト内の全ての関数をテストする場合、open testingを使う
contract WETH_Open_Invariant_Tests is Test {
    WETH public weth;

    function setUp() public {
        weth = new WETH();
    }

    //total supply of WETH is always zero. 
    //Because the invariant test always called functions 
    //inside WETH with 0 ETH (msg.amount = 0).
    function invariant_totalSupply_is_always_zero() public {
        assertEq(weth.totalSupply(), 0);
    }
}