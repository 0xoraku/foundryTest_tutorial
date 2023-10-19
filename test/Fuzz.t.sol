//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Bit} from "../src/Bit.sol";

contract FuzzTest is Test {
    Bit public b;

    function setUp() public {
        b = new Bit();
    }

    /**
     * この関数は、与えられた256ビットの整数の最上位ビットの位置を返すため
     * に使用されます。
     * 関数は、与えられた整数を1ビットずつ右にシフトし、
     * 0になるまで繰り返します。
     * このプロセスで、シフトされた回数が最上位ビットの位置になります。
     * 最後に、この位置が返されます。
     */
    function mostSignificantBit(uint256 x) private pure returns (uint256) {
        uint256 i = 0;
        while ((x >>= 1) > 0) {
            i++;
        }
        return i;
    }

    function testMostSignificantBitManual() public {
        assertEq(b.mostSignificantBit(0), 0);
        assertEq(b.mostSignificantBit(1), 0);
        assertEq(b.mostSignificantBit(2), 1);
        assertEq(b.mostSignificantBit(4), 2);
        assertEq(b.mostSignificantBit(8), 3);
        assertEq(b.mostSignificantBit(type(uint256).max), 255);
    }

    //上記で行ったinputをランダム値に変更して実行する
    //引数に(uint256 x)を指定すると、ランダムな値が入る
    function testMostSignificantBitFuzz(uint256 x) public {
        // assume - If false, the fuzzer will discard the current fuzz inputs
        //          and start a new fuzz run
        // Skip x = 0
        // vm.assume(x > 0);
        // assertGt(x, 0);

        // bound(input, min, max) - bound input between min and max
        // Bound
        x = bound(x, 1, 10);
        // assertGe(x, 1);
        // assertLe(x, 10);
        uint256 i = b.mostSignificantBit(x);
        assertEq(i, mostSignificantBit(x));
    }
}
