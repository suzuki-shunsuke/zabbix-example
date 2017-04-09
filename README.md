# zabbixを使って監視をする

1. Dockerを使ってzabbixのサーバとフロントエンドとエージェントを動かす
2. zabbix-agentのイメージを継承してpythonのflaskアプリケーションを動かすイメージを作る
3. flaskアプリケーションのポートとプロセスを監視する

## セットアップ

```
$ docker-compose up -d
```

http://localhost:10000 にアクセス

* username: Admin
* password: zabbix

でログイン

1. エージェントのコンテナをhostとして追加
2. テンプレートを作成し、コンテナに関連付ける
3. テンプレートにアイテムを追加する
  1. flaskのポートを監視
  2. flaskのプロセスを監視
4. トリガを作成する
5. メディアタイプを作成し、通知を飛ばすようにする

## Flaskアプリケーション

zabbix-agent アプリケーションはsupervisorを使っていたので、supervisorのサブプロセスとして
flaskアプリケーションを動かす。

監視の設定をした状態でsupervisorctlコマンドを使ってflaskを停止したり起動したりしてちゃんと監視できているか確認する

## 関連リンク

* https://hub.docker.com/r/zabbix/zabbix-agent/
* [zabbix 2.2 日本語ドキュメント](https://www.zabbix.com/documentation/2.2/jp/manual/introduction) バージョンは古いけど参考になる
* https://www.sraoss.co.jp/technology/zabbix/
* [ZabbixでDockerコンテナを簡単に監視する](http://dev.classmethod.jp/cloud/zabbix-docker-monitoring/)
* [zabbixからslackに通知を送る](http://qiita.com/takashyx/items/3c9becf345cd58ca69bf)

## hostの設定

* DNS名としてdocker-composeのサービス名を指定

## ポートのチェックの設定

flaskを5000で動かすので5000をチェックする

key | value
--- | ---
Type | Zabbix agent
Key | net.tcp.port[,5000]
Type of information | Numeric (unsigned)
Data type | Decimal
Update interval (in sec) | 3

## プロセスのチェックの設定

flaskは

```
$ python3 main.py
```

というコマンドで起動する

key | value
--- | ---
Type | Zabbix agent
Key | proc.num[,root,sleep,python3 main.py]
Type of information | Numeric (unsigned)
Data type | Decimal
Update interval (in sec) | 3
