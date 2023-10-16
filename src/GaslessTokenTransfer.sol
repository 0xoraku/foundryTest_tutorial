// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20Permit} from "./interfaces/IERC20Permit.sol";

/**
 * この関数は、ERC20Permitという名前の別のコントラクトを使用して、
 * トークンの送信を許可します。
 * permit 関数は、送信者がトークンを送信するために必要な署名を検証し、
 * トークンの送信を許可します。
 * その後、関数は、transferFrom 関数を使用して、トークンを送信し、
 * 手数料を支払います。最後に、手数料が送信者に送信されます。
 */

contract GaslessTokenTransfer {
    function send(
        address token,
        address sender,
        address receiver,
        uint256 amount,
        uint256 fee,
        uint256 deadline,
        // Permit signature
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        // Permit
        //permit 関数は、送信者がトークンを送信するために必要な署名を検証し、
        //トークンの送信を許可します。
        IERC20Permit(token).permit(sender, address(this), amount + fee, deadline, v, r, s);
        // Send amount to receiver
        IERC20Permit(token).transferFrom(sender, receiver, amount);
        // Take fee - send fee to msg.sender
        IERC20Permit(token).transferFrom(sender, msg.sender, fee);
    }
}
