FROM rocker/ml

USER root

RUN rm /etc/dpkg/dpkg.cfg.d/excludes \
  && sed -i -e 's%http://[^ ]\+%mirror://mirrors.ubuntu.com/mirrors.txt%g' /etc/apt/sources.list \
  && wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin \
  && mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600 \
  && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/7fa2af80.pub \
  && add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/ /" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    cuda \
    curl \
    default-jdk \
    dnsutils \
    iputils-ping \
    less \
    libcudnn8 \
    libglpk-dev \
    libnode64 \
    libtbb2 \
    libxt6 \
    net-tools \
    vim-tiny \
  && apt-get --reinstall install -y man-db coreutils manpages \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && yes | unminimize

RUN Rscript -e ' \
  options(Ncpus = 32); \
  options(repos = "https://cran.ism.ac.jp"); \
  install.packages("keras"); \
  keras::install_keras(tensorflow = "gpu");'

USER rstudio

RUN Rscript -e ' \
  options(Ncpus = 32); \
  options(repos = "https://cran.ism.ac.jp"); \
  Sys.setenv(DOWNLOAD_STATIC_LIBV8=1); \
  install.packages(c( \
    "caret", \
    "doParallel", \
    "e1071", \
    "epitools", \
    "exactci", \
    "fable", \
    "factoextra", \
    "feasts", \
    "forecast", \
    "furrr", \
    "ggfortify", \
    "ggrepel", \
    "ggmosaic", \
    "glmnetUtils", \
    "gplots", \
    "gridExtra", \
    "h2o", \
    "igraph", \
    "lintr", \
    "MLmetrics", \
    "neuralnet", \
    "pastecs", \
    "prophet", \
    "PRROC", \
    "pryr", \
    "psych", \
    "randomForest", \
    "rpart.plot", \
    "tsibble", \
    "vcd" \
  )); \
  remotes::install_version("xgboost", version = "1.4.1.1"); \
  remotes::install_github(c("vqv/ggbiplot"));'

WORKDIR /home/rstudio

USER root
