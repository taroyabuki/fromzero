# RStudio用のコンテナ（Apple Chip）

Docker Hub: https://hub.docker.com/r/taroyabuki/rstudio-mac

Apple Chipでは，11章のコードは実行できません．11章を読む際には，Google Colabを使ってください（[R](../code/R-notebook)・[Python](../code/Python-notebook)）．

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
