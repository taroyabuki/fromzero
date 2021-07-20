# RStudio

https://hub.docker.com/r/taroyabuki/rstudio

## 使い方

```bash
docker run \
-d \
-e PASSWORD=password \
-e ROOT=TRUE \
-p 8787:8787 \
-v $(pwd):/home/rstudio/work \
--name rs \
taroyabuki/rstudio
```

- パスワードを変える場合は，「`-e PASSWORD=新しいパスワード`」とする．
- ホスト側で8787を使っているなら，`-p 8080:8787`などとして，別のポートを使う．

ブラウザでhttp://localhost:8787 を開く．（ポートを変えた場合は数値を変える．）

## 起動スクリプト

起動スクリプトをダウンロードしておけば，`sh rstudio.sh`で起動できる．（パスワードやポートを返る場合はrstudio.shを編集する．）

```bash
wget https://raw.githubusercontent.com/taroyabuki/rp/master/docker/rstudio.sh
```
