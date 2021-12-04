# Jupyter Notebook用のコンテナ

Docker Hub: https://hub.docker.com/r/taroyabuki/jupyter

- Apple Chipについての注意
    - [Docker desktop 4.0.1](https://docs.docker.com/desktop/mac/release-notes/#docker-desktop-401)で動作すること，4.1から4.3では動作しないことを確認しています（それ以降は未確認）．
    - 11章のコードは実行できません．11章を読む際には，Google Colabを使ってください（[R](../code/R-notebook)・[Python](../code/Python-notebook)）．
- 起動スクリプト：[jupyter.sh](../jupyter.sh)
- Jupyter Notebookへのアクセス：http://localhost:8888

次のようにして起動スクリプトをダウンロードしておけば，`sh jupyter.sh`で起動できます．

```bash
wget https://raw.githubusercontent.com/taroyabuki/rp/master/docker/jupyter.sh
```

`git clone https://github.com/taroyabuki/fromzero.git`の後で，`sh fromzero/docker/jupyter.sh`として起動することもできます．
