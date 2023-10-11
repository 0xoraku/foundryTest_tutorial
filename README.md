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
