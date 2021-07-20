# Jupyter Notebook

https://hub.docker.com/r/taroyabuki/jupyter

## 使い方

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

- パスワードを変える場合は，「`--NotebookApp.token='新しいパスワード'`」とする．
- ホスト側で8787を使っているなら，`-p 8080:8888`などとして，別のポートを使う．

ブラウザでhttp://localhost:8888 を開く．（ポートを変えた場合は数値を変える．）

## 起動スクリプト

起動スクリプトをダウンロードしておけば，`sh jupyter.sh`で起動できる．（パスワードやポートを変える場合はjupyter.shを編集する．）

```bash
wget https://raw.githubusercontent.com/taroyabuki/rp/master/docker/jupyter.sh
```
