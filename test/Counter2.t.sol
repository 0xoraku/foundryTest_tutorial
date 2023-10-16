// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Counter2} from "../src/Counter2.sol";

contract Counter2Test is Test {
    Counter2 public counter;

    function setUp() public {
        counter = new Counter2();
    }

    function testLogPrint() public {
        console2.log("testLogPrint");
        int256 x = -1;
        console2.log(x);
        console2.logInt(x);
    }

    function testInc() public {
        counter.inc();
        assertEq(counter.count(), 1);
    }

    //エラーを想定した書き方
    function testFailDec() public {
        //countが0を下回るとエラーになる
        counter.dec();
    }

    function testDecUnderflow() public {
        vm.expectRevert(); //"Arithmetic over/underflow"
        counter.dec();
    }

    function testDec() public {
        counter.inc();
        counter.inc();
        counter.dec();
        assertEq(counter.count(), 1);
    }
}
