# dockerfile

## dockerfileの一例

 Use an exisitng docker image as a base

```FROM alpine```

 Download and install a dependency

```RUN apk add --update redis```

 Tell the image what to do when it starts
 as a container

```CMD ["redis-server"]```

* FROM: ベースとなるimageを指定。OSを指定。
* RUN:  カスタムイメージを構成する他のシステムを操作するコマンド
* CMD: カスタムイメージをもとにコンテナを立ち上げる時に実行されるコマンド

* alpine: 軽量のLinuxディストリビューション。redisのインストールが簡単なためalpineを選択。


## BuildKit

* dockerfileのビルド時、FROM,RUN,CMDの順に処理していた直列なコードを並列で処理できるようになる
* FROM~CMDのログの詳細を確認する場合はBuildKitをoffにする
### BuildKit設定方法

* dockerDesktop: 設定ボタン: docker engine: 設定ファイルの"buildkit: true or false"

## dockerfile流れ

FROM alpine
RUN apk add --update redis
CMD ["redis-server"]

* Fromフェーズ
  1. ベースとなるalpineイメージをローカルまたはDockerHubから検索。システムのOS部分。

* RUNフェーズ
  1. ベースのOSを元に仮のコンテナを作成。alpineのファイルシステムがコンテナのハードドライブに組み込まれる
  2. alpineに ```apk add --update redis```でredisをコンテナのハードドライブにインストールする
  3. FROM,RUNの情報を持つ仮コンテナを削除し、そのコンテナを作成する新たな仮イメージが生成される

* CMDフェーズ
  1. CMDフェーズで指定したコマンドはコンテナ稼働時に実行されるもので、RUNフェーズのコンテナにCMDフェーズのコマンドが実行されるよう設定する。この際仮のRUNフェーズのイメージからFROM,RUN,CMDを合わせた仮のCMDフェーズコンテナが作成される。
  2. 仮のCMDフェーズコンテナを削除し、このコンテナを立ち上げるイメージが最終的なdockerfileから作られたイメージとなる。

* ```docker build .```で実行
  1. ```docker build 作成するイメージの名前[:タグ名] .``` : dockerfileから作成するイメージに名前を付けられる。オプションでタグ(バージョン)を付けられ、省略するとlatest(最新)になる

* ```docker run イメージのID or 名前[:タグ名]```
  1. タグを省略するとデフォルトでlatestになる

## Using cache

  * 一度読み込んだイメージは２回目以降読み込む際、コードに変化がない場合は```Using cache```と表示される。
  * 前回読み込まれた仮のイメージのキャッシュが残っており、再利用できる
  * 同じイメージを作成しても、順番が違うと違うイメージとして認識される。相違点が発見されたイメージから同じイメージであっても再読み込みされる。

