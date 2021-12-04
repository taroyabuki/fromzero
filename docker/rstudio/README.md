# RStudio用のコンテナ

Docker Hub: https://hub.docker.com/r/taroyabuki/rstudio

## 使い方

1. コンテナを構築する．

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

2. ブラウザで http://localhost:8787 にアクセスする．

### 起動スクリプト

次のようにして起動スクリプトをダウンロードしておけば，`sh rstudio.sh`で起動できます．

```bash
wget https://raw.githubusercontent.com/taroyabuki/rp/master/docker/rstudio.sh
```

パスワードやポートを変える場合はrstudio.shを編集します．
