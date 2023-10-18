## Foundry Test
[Smart Contract Programmerのtutorial](https://www.youtube.com/watch?v=tgs5q-GJmg4&list=PLO5VPQH6OWdUrKEWPF07CSuVm3T99DQki)

## CLI
### 特定のファイルだけテストする
```bash
forge test --match-path test/HelloWorld.t.sol
```

### gas使用量を表示する
```bash
forge test --match-path test/Counter2.t.sol --gas-report
```


## foundry.tomlの設定
### 特定のversionでcompileしたい場合
```bash
solc_version = "0.8.17"
```

### 他のgithub等のlibraryを使う場合
remappingsを使う

#### CLIの場合
```bash
forge remappings
```
```bash
結果の例
ds-test/=lib/solmate/lib/ds-test/src/
forge-std/=lib/forge-std/src/
solmate/=lib/solmate/src/
```

#### 削除する場合
```bash
forge remove -f lib/solmate
```


### formatの設定
```bash
forge fmt
```

## testの実行者のアドレスを変更する
```bash
# 次の行の実行者アドレスを変更する
vm.prank()

# stopまで実行者のアドレスを変更する
vm.startPrank();
vm.stopPrank();
```

## Errorをテストする
### 一般的な書き方
```bash
vm.expectRevert();
#ここに該当する式などを書く
``` 

### requireのerror文をチェックしたい場合
```bash
vm.expectRevert(bytes("error message"));
#ここに該当式
```
### errorやrevertで設定するカスタムエラーをチェックしたい場合
```bash
# error NotAuthorized();の場合
vm.expectRevert(Error.NotAuthorized.selector);
#ここに該当式
```
### assertにlabelをつけて、-vvvなどでlogを追いたい場合
```bash
# 通常のassert
assertEq(uint256(1), uint256(1));
# labelをつけたassert
assertEq(uint256(1), uint256(1), "test 1");
```

## Eventのテスト

### vm.expectEmit()の構成は次の通り
```solidity
   function expectEmit(
             bool checkTopic1,
             bool checkTopic2,
             bool checkTopic3,
             bool checkData
    ) external;
```
#### 例
```solidity
        // 1. どのデータをチェックするかを指定する
        // 例）index 1, index 2 そして dataをチェックする場合
        vm.expectEmit(true, true, false, true);
        // 2. Emitで期待されるイベントを発生させる
        emit Transfer(address(this), address(123), 456);
        // 3. イベントを発生させる関数を呼び出す
        e.transfer(address(this), address(123), 456);
```

## 時間に関するテスト

### 用語
```bash
    # set block.timestamp to future timestamp
    # 引数にblock.timestamp + 1 hour　等を指定する
    vm.warp()

    # set block.number
    # 引数値にblock.numberを指定する
    # vm.roll(100)ならblock.numberを100にする
    vm.roll()

    # increment current timestamp
    # 引数秒分だけ進めるskip(10)なら10秒進める
    skip()

    # decrement current timestamp
    # 引数秒分だけ戻すrewind(10)なら10秒戻す
    rewind()
```

## send Eth(Recieve関数)のテスト
### 用語
```bash
# addressにbalanceを設定する
deal(address, uint)

# deal + prank
# addressにbalanceを設定し、それの実行者とする
hoax(address, uint)

```

## 署名のテスト(ecrecover)
### 用語
#### ecrecoverとは
```bash
ecrecoverは、EthereumのSolidityプログラミング言語に組み込まれた低レベルの関数で、楕円曲線デジタル署名アルゴリズム（ECDSA）を利用して署名から公開鍵を復元するのに使用されます。これは、特定のデータが特定のアドレス/個人によって署名されたことを検証する際に、非常に重要な機能です。

ここでの「復元」とは、公開鍵またはEthereumアドレスを取得することを指し、これによってその署名が特定のアカウントにリンクされたものであることを確認できます。
```

#### signの流れ
```bash
秘密鍵を設定
公開鍵を設定
メッセージを設定
メッセージをハッシュ化
秘密鍵とハッシュ化したメッセージから署名を作成
```

```solidity
    uint256 privateKey = 123;
    address pubKey = vm.addr(privateKey);

    bytes32 messageHash = keccak256("secret message");
    //秘密鍵とハッシュ化されたメッセージを署名
    (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);
    
    //ecrecoverは、署名されたメッセージから公開鍵を復元する。
    address signer = ecrecover(messageHash, v, r, s);
```

## gas-less token transfer (ERC20permit)のテスト
[gas-less token transfer自体の解説動画](https://www.youtube.com/watch?v=rucZrL1nOO8)


## Fuzz Testing

FuzzingはSolidity コントラクトのランダムなテスト入力を生成します。

### fuzz
test関数名()の引数を指定すると、その引数に対してランダムな値を入れてテストを実行する。
```solidity
// この場合は(uint256 x)
function testMostSignificantBitFuzz(uint256 x) public {
    ...
}
```

### assume and bound
#### assume
assumeとは、boolを引数に取り、falseだった場合は現在のfuzzテストをスキップし、次の新たなfuzzテストを実行する。
xが0以下の場合はスキップしたいケース
```solidity
vm.assume(x > 0);
assertGt(x, 0);
```

#### bound
boundは、fuzzの範囲を指定する。
bound(input, min, max)のように指定する。
```solidity
x = bound(x, 1, 10);
assertGe(x, 1);
assertLe(x, 10);
```

#### stats
fuzz testをすると、コンソールの出力に次のような(runs, μ, ~)が表示される。
```bash
テストした関数名  (runs: 256, μ: 10837, ~: 10966)
# runs: 256は、256回テストを実行したことを示す。
# μ: 10837は、gas使用量の平均値を示す。
# ~: 10966は、gas使用量の中間値を示す。
```

## Invariant(不変) Testing
### fuzzとinvariantとの違い
fuzzingは、ランダムな入力を単一の関数に渡して複数回テストを実行する。
invariantは、一連の関数をランダムに呼び出し、複数回テストを実行する。

#### Failing invariant例
```solidity
contract IntroInvariant {
    bool public flag;

    function func_1() external{}
    //...
    function func_5() external{
        flag = true;
    }
}

contract IntroInvariantTest is Test{
    //IntroInvariantコントラクトをtargetとして呼び出し
    //...
    function invariant_flag_is_always_false() public {
        //ここでflagがfalseであることを確認するために
        //target.func_1()～target.func_5()をランダムに呼び出す
        assertEq(target.flag(), false);
    }
}
```

#### passing invariant例
```solidity
contract WETH {
    /*
    ethをwrappingするコントラクトで、
    depositやwithdraw,approve,transfer等を行う関数がある
    */
}

contract contract WETH_Open_Invariant_Tests{
    //setup
    //...

    function invariant_totalSupply_is_always_zero() public {
        //ここでwethのtotalSupplyが複数の関数を実行した後も
        //0であることを確認
        assertEq(weth.totalSupply(), 0);
    }
}
```
結果
```bash
invariant_totalSupply_is_always_zero() (runs: 256, calls: 3840, reverts: 2226)
# runs: 256は、256回テストを実行したことを示す。
# calls: 3840は、3840回関数を呼び出したことを示す。
# reverts: 2226は、2226回revertしたことを示す。
# ここでrevert回数が多いのは、例えばwithdrawのamountが
# balanceより多い場合などにrevertするため。
```

## Handler Based Testing
Handler based testing: 特定の条件下でコントラクトをテストすること。
passing invariantでは例えばdeposit関数を実行してもvalueは0のままだった。
ここで、msg.valueに1を設定してdeposit関数を実行した場合に、valueが1になるかもテストしたい場合等に使う。

### Handler based testingの構成
WETH contract <- Handler contract <- Test contract
という形にする。
Handler contractは、WETH contractの関数を呼び出す関数を持つ。
この時、各関数でmsg.value等の範囲をboundで設定することで、
特定の値を入力した際の関数をテストできる。
最後に、Test contractでHandler contractの関数を呼び出す。
この際、以下のようにすることでweth,handler双方をテスト
するのではなく、target contractのみのinvariant testが可能となる。

```solidity
targetContract(address(handler));
```
更に、target selectorを指定することで、特定の関数のみをテストすることも可能となる。
```solidity
// target selectorを指定しておく。
//selectors[0] = Handler.deposit.selector;等
targetSelector(
            FuzzSelector({
                addr: address(handler),
                selectors: selectors
            })
        );
```

### 複数のhandlerを呼び出す-Actor management
Actor management contract: 上記のHandlerをランダムに呼び出す
WETH contract <- Handler contract <- Actor management contract <- Test contract

 Actor management contract
```solidity
    Handler[] public handlers;

    constructor(Handler[] memory _handlers) {
        handlers = _handlers;
    }

    //handlerIndexは、handlersからランダムに選択される
    function sendToFallback(uint handlerIndex, uint amount) public{...}
    //...他の関数も同じようにhandlerIndexを設定する
```
test
1. Actor management contractで設定した分のhandlerを呼び出す(handlersに格納する)
2. Actor management contractを初期化。この際、引数に1.で設定したhandlerを渡す
3. targetContract()に２．で作成したものを渡す
4. testではhandlers格納数分を呼び出す関数を複数呼び出す。


## FFI(foreign function interface)
Linuxコマンド等、テスト内から他のプログラムを実行すること
```solidity
//可変長配列を用意。
//１つ目にコンテンツ、２つ目にファイル名を指定する。
//以下の引数に渡してあげる
vm.ffi(String配列)
//返り値はbytes型
```
forge testする際は、--ffiオプションをつける
```bash
forge test --match-path test/FFI.t.sol --ffi -vvv

# 結果
Logs:
  Hello
Foundry
```


