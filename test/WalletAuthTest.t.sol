// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";

// forge test --match-path test/Auth.t.sol -vvvv

contract WalletAuthTest is Test {
    Wallet public wallet;
    //仮のユーザー名の仮のアドレス作成
    address user = makeAddr("user");

    function setUp() public {
        // vm.prank(user);
        wallet = new Wallet();
        console.log("msg.sender is :", msg.sender);
        console.log("owner address is :", wallet.owner());
    }

    function testSetOwner() public {
        // vm.prank(user);
        wallet.setOwner(address(1));
        assertEq(wallet.owner(), address(1));
        // console.log("owner", wallet.owner());
        // console.log("adddress(1) is: ", address(1));
        // console.log("user is: ", user);
        // vm.prank(user);
        // wallet.setOwner(user);
        // assertEq(wallet.owner(), user);
        // vm.prank(user);
        // wallet.setOwner(address(1));
        // assertEq(wallet.owner(), address(1));
    }

    function testFailNotOwner() public {
        vm.prank(user);
        //wallet contractのOwnerはWalletAuthTestのアドレス
        //なので、以下は、エラーになる。
        wallet.setOwner(address(1));
    }

    /**
     vm.prankは次の行のみ。
     vm.startPrankはstopがかかるまで引数のアドレスをmsg.senderとして扱う。
     */
    function testFailSetOwnerAgain() public {
        // vm.startPrank(user);
        wallet.setOwner(address(1));

        vm.startPrank(address(1));
        wallet.setOwner(address(1));
        wallet.setOwner(address(1));
        wallet.setOwner(address(1));
        vm.stopPrank();

        //msg.sender = address(this)
        //上記作業でownerはaddress(1)になっている。
        //従って、下はエラーになる。
        wallet.setOwner(address(1));
    }



    // Wallet public wallet;

    // function setUp() public {
    //     wallet = new Wallet();
    // }

    // function testSetOwner() public {
    //     wallet.setOwner(address(1));
    //     assertEq(wallet.owner(), address(1));
    // }

    // function testFailNotOwner() public {
    //     // next call will be called by address(1)
    //     vm.prank(address(1));
    //     wallet.setOwner(address(1));
    // }

    // function testFailSetOwnerAgain() public {
    //     // msg.sender = address(this)
    //     wallet.setOwner(address(1));

    //     // Set all subsequent msg.sender to address(1)
    //     vm.startPrank(address(1));

    //     // all calls made from address(1)
    //     wallet.setOwner(address(1));
    //     wallet.setOwner(address(1));
    //     wallet.setOwner(address(1));

    //     // Reset all subsequent msg.sender to address(this)
    //     vm.stopPrank();

    //     console.log("owner", wallet.owner());

    //     // call made from address(this) - this will fail
    //     wallet.setOwner(address(1));

    //     console.log("owner", wallet.owner());
    // }
}