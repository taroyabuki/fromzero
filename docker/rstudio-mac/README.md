# RStudio用のコンテナ（Apple Silicon）

Docker Hub: https://hub.docker.com/r/taroyabuki/rstudio-mac

- [Docker desktop 4.0.1](https://docs.docker.com/desktop/mac/release-notes/#docker-desktop-401)で動作すること，4.1から4.2では動作しないことを確認しています（それ以降は未確認）．
- 11章のコードは実行できません．Google Colabを使ってください（[R](../code/R-notebook)・[Python](../code/Python-notebook)）．

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
taroyabuki/rstudio-mac
```

2. ブラウザで http://localhost:8787 にアクセスする．

### 起動スクリプト

次のようにして起動スクリプトをダウンロードしておけば，`sh rstudio-mac.sh`で起動できます．

```bash
wget https://raw.githubusercontent.com/taroyabuki/rp/master/docker/rstudio-mac.sh
```

パスワードやポートを変える場合はrstudio-mac.shを編集します．
