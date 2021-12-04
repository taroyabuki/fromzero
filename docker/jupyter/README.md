# Jupyter Notebook用のコンテナ

Docker Hub: https://hub.docker.com/r/taroyabuki/jupyter

Apple Chipについての注意

- [Docker desktop 4.0.1](https://docs.docker.com/desktop/mac/release-notes/#docker-desktop-401)で動作すること，4.1から4.3では動作しないことを確認しています（それ以降は未確認）．
- 11章のコードは実行できません．11章を読む際には，Google Colabを使ってください（[R](../code/R-notebook)・[Python](../code/Python-notebook)）．

## 使い方

1. コンテナを構築する．

```bash
docker run \
-d \
-p 8888:8888 \
-v $(pwd):/home/jovyan/work \
--name jr \
taroyabuki/jupyter \
start-notebook.sh \
--NotebookApp.token='password'
```

2. ブラウザで http://localhost:8888 にアクセスする．

### 起動スクリプト

次のようにして起動スクリプトをダウンロードしておけば，`sh jupyter.sh`で起動できます．

```bash
wget https://raw.githubusercontent.com/taroyabuki/rp/master/docker/jupyter.sh
```

パスワードやポートを変える場合はjupyter.shを編集します．
