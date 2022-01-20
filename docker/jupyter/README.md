# Jupyter Notebook用のコンテナ

- Docker Hub: https://hub.docker.com/r/taroyabuki/jupyter
- 起動方法（3種類）
    - [rstudio.sh](../rstudio.sh)を実行する．
    - `wget https://raw.githubusercontent.com/taroyabuki/rp/master/docker/jupyter.sh`の後で，`sh jupyter.sh`
    - `git clone https://github.com/taroyabuki/fromzero.git`の後で，`sh fromzero/docker/jupyter.sh`
- Jupyter Notebookへのアクセス：http://localhost:8888
- Apple Chipについての注意
    - Docker desktop 4.4.2で動作することを確認しています．（4.1から4.3では動作しませんでした．）
    - 11章のコードは実行できません．11章を読む際には，Google Colabを使ってください（[R](../code/R-notebook)・[Python](../code/Python-notebook)）．
