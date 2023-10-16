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