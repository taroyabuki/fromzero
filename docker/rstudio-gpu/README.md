# RStudio用のコンテナ（NVIDIAのGPU）

- Docker Hub: https://hub.docker.com/r/taroyabuki/rstudio-gpu
- 起動方法（3種類）
    - [rstudio-gpu.sh](../rstudio-gpu.sh)を実行する．
    - `wget https://raw.githubusercontent.com/taroyabuki/rp/master/docker/rstudio-gpu.sh`の後で，`sh rstudio-gpu.sh`
    - `git clone https://github.com/taroyabuki/fromzero.git`の後で，`sh fromzero/docker/rstudio-gpu.sh`
- RStudio Serverへのアクセス：http://localhost:8787
- Windows 10で使うための準備
    1. https://www.microsoft.com/ja-jp/software-download/windows10 でWindowsを最新にする．
    1. https://developer.nvidia.com/cuda/wsl からCUDA Driverをダウンロード，インストールする．
    1. `docker run --rm --gpus all nvcr.io/nvidia/k8s/cuda-sample:nbody nbody -gpu -benchmark`（GPUの動作確認）
