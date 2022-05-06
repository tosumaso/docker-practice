# Use an exisitng docker image as a base
FROM alpine

# Download and install a dependency
RUN apk add --update redis

# Tell the image what to do when it starts
# as a container
CMD ["redis-server"]

# FROM: ベースとなるimageを指定。OSを指定。
# RUN:  カスタムイメージを構成する他のシステムを操作するコマンド
# CMD: カスタムイメージをもとにコンテナを立ち上げる時に実行されるコマンド

# alpine: 軽量のLinuxディストリビューション。redisのインストールが簡単なためalpineを選択。


#BuildKit: dockerfileのビルド時、FROM,RUN,CMDの順に処理していた直列なコードを並列で処理できるようになる
#FROM~CMDのログの詳細を確認する場合はBuildKitをoffにする
# BuildKit設定方法
# dockerdesktop: 設定ボタン: docker engine: 設定ファイルの"buildkit: true or false"