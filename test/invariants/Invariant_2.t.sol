// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {WETH} from "../../src/WETH.sol";

// Topics
// - handler based testing - test functions under specific conditions
// - target contract
// - target selector

import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";



contract Handler is CommonBase, StdCheats, StdUtils {
    WETH private weth;
    //Handler contractによって、wethのbalanceが
    //どの程度変化したかを記録する
    uint public wethBalance;

    constructor(WETH _weth) {
        weth = _weth;
    }

    receive() external payable{}

    //WETHコントラクトのrecieve関数に送金する
    //これはreceive関数内でdeposit関数を呼び出しているため
    function sendToFallback(uint amount) public {
        //このコントラクト(Handler)のbalanceの範囲内でランダム値を生成する(bound)
        amount = bound(amount, 0, address(this).balance);
        
        wethBalance += amount;

        //fallbackの呼び出し
        (bool ok, ) = address(weth).call{value: amount}("");
        require(ok, "sendToFallback failed");
    }

    function deposit(uint amount) public {
        amount = bound(amount, 0, address(this).balance);
        wethBalance += amount;
        //ランダム値のamountを預ける
        weth.deposit{value: amount}();
    }

    function withdraw(uint amount) public {
        //Handlerで初期化したWETHコントラクトのbalanceの範囲内に設定
        amount = bound(amount, 0, weth.balanceOf(address(this)));
        wethBalance -= amount;
        weth.withdraw(amount);
    }

    function fail() public {
        revert("failed");
    }
}

//WethとHandlerのinvariant test
contract WETH_Handler_Based_Invariant_Tests is Test {
    WETH public weth;
    Handler public handler;

    function setUp() public {
        weth = new WETH();
        handler = new Handler(weth);

        //HandlerコントラクトにETHを送金する
        deal(address(handler), 100 * 1e18);
        //このコントラクトではweth, handlerの２つをdeployしているが、
        //invariant testはhandlerのみをtargetとしたい。
        targetContract(address(handler));

        //targetContractより更に特定した関数のみをtestしたい場合、
        //以下のように記述する。
        //今回はsendToFallback, deposit, withdrawの３つをtestする。
        bytes4[] memory selectors = new bytes4[](3);
        selectors[0] = Handler.deposit.selector;
        selectors[1] = Handler.withdraw.selector;
        selectors[2] = Handler.sendToFallback.selector;
        // targetSelector("sendToFallback(uint256)");
        targetSelector(
            FuzzSelector({
                addr: address(handler),
                selectors: selectors
            })
        );
    }

    //wethのbalanceがhandlerのwethBalance以上であることを確認する
    //多分同じ額のassertEq()の方がいいかも。
    function invariant_eth_balance() public {
        assertGe(address(weth).balance, handler.wethBalance());
    }
}