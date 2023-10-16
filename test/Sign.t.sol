pragma solidity ^0.8.18;

import "forge-std/Test.sol";

contract SignTest is Test {
    // private key = 123
    // public key = vm.addr(private key)
    // message = "secret message"
    // message hash = keccak256(message)
    // vm.sign(private key, message hash)

    /*
    *Ethereumの環境では、トランザクションやメッセージを署名する際に、
    ECDSA（Elliptic Curve Digital Signature Algorithm）という暗号署名アルゴリズムが使用されます。
    このアルゴリズムによって生成される署名は、大きく分けて3つの部分、v、r、sから構成され、
    これらは以下のような意味を持っています。

    rとs:

    これらは、ECDSA署名の実際の署名値です。
    特定のメッセージと秘密鍵を使用して生成される値で、
    楕円曲線暗号の計算プロセスの一部として直接計算されます。
    rは署名における一意のX座標の値、sは署名計算から得られる一意の値です。
    これらは、署名の正当性を検証し、署名者の公開鍵（あるいはEthereumの環境ではアドレス）
    を復元するために使用されます。

    v:

    vはリカバリーIDと呼ばれ、署名されたデータとr、s値から正しい楕円曲線の公開鍵を復元する際に、
    どの楕円曲線を使用すべきかを示すための値です。
    基本的に、この値は公開鍵の復元プロセスにおいて、
    正しい解（公開鍵が2つ存在する可能性がある）を選択するために使用されます。
    Ethereumでは、この値はまた、トランザクションがEthereumのメインネットワーク上で行われたか、
    あるいはテストネット上で行われたかを区別するためにも使われることがあります。

     */

    function testSignature() public {
        uint256 privateKey = 123;
        address pubKey = vm.addr(privateKey);

        bytes32 messageHash = keccak256("secret message");
        //秘密鍵とハッシュ化されたメッセージを署名
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);
        
        //eccrecoverは、署名されたメッセージから公開鍵を復元する。
        address signer = ecrecover(messageHash, v, r, s);

        assertEq(signer, pubKey);

        //signをしないと、ハッシュ化されたメッセージから公開鍵を復元できない。
        bytes32 invalidHash = keccak256("Invalid message");
        //ここで本来はsignをする
        //上で使った署名値を使って復元を試みる
        signer = ecrecover(invalidHash, v, r, s);
        //復元できないので、pubKeyとは異なる
        assertTrue(signer != pubKey);

    }



    // function testSignature() public {
    //     uint256 privateKey = 123;
    //     // Computes the address for a given private key.
    //     address alice = vm.addr(privateKey);

    //     // Test valid signature
    //     bytes32 messageHash = keccak256("Signed by Alice");

    //     (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);
    //     address signer = ecrecover(messageHash, v, r, s);

    //     assertEq(signer, alice);

    //     // Test invalid message
    //     bytes32 invalidHash = keccak256("Not signed by Alice");
    //     signer = ecrecover(invalidHash, v, r, s);

    //     assertTrue(signer != alice);
    // }
}