// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";


contract WalletSendEthTest is Test {
    Wallet public wallet;

    function setUp() public {
        wallet = new Wallet{value: 1e18}();
    }

    function _send(uint256 amount) private {
        (bool ok, ) = address(wallet).call{value: amount}("");
        require(ok, "send failed");
    }

    function testEthBalance() public {
        console.log("Eth balance: ", address(this).balance/1e18);
    }

    function testSendEth() public {
        uint bal = address(wallet).balance;
        //address(1)を100etherに設定
        deal(address(1), 100);
        assertEq(address(1).balance, 100);

        //address(1)に10に設定。ここでは上の100は引き継がれない。
        deal(address(1), 10);
        assertEq(address(1).balance, 10);

        //address(1)を送信者として、walletContractに123etherを送金
        //walletContractのrecieve関数が呼ばれ,eventが発火する
        deal(address(1), 123);
        vm.prank(address(1));
        _send(123);

        //上の３行をhoax()を使って短縮
        hoax(address(1), 456);
        _send(456);
        
        assertEq(address(wallet).balance, bal + 123 + 456);
    }

}