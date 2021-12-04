# Jupyter Notebook用のコンテナ

Docker Hub: https://hub.docker.com/r/taroyabuki/jupyter

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
