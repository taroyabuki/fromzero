# RStudio用のコンテナ（GPU）

Docker Hub: https://hub.docker.com/r/taroyabuki/rstudio-gpu

## 準備（Windows 10）

Windows 10で使うための準備をします．

1. https://www.microsoft.com/ja-jp/software-download/windows10 でWindowsを最新にする．
1. https://developer.nvidia.com/cuda/wsl からCUDA Driverをダウンロード，インストールする．
1. `docker run --rm --gpus all nvcr.io/nvidia/k8s/cuda-sample:nbody nbody -gpu -benchmark`（GPUの動作確認）


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
taroyabuki/rstudio-gpu
```

2. ブラウザで http://localhost:8787 にアクセスする．

### 起動スクリプト

次のようにして起動スクリプトをダウンロードしておけば，`sh rstudio-gpu.sh`で起動できます．

```bash
wget https://raw.githubusercontent.com/taroyabuki/rp/master/docker/rstudio-gpu.sh
```

パスワードやポートを変える場合はrstudio-gpu.shを編集します．
