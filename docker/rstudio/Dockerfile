FROM rocker/tidyverse

USER root

RUN rm /etc/dpkg/dpkg.cfg.d/excludes \
  && sed -i -e 's%http://[^ ]\+%mirror://mirrors.ubuntu.com/mirrors.txt%g' /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    default-jdk \
    dnsutils \
    iputils-ping \
    less \
    libglpk-dev \
    libnode64 \
    libtbb2 \
    net-tools \
    vim-tiny \
  && apt-get --reinstall install -y man-db coreutils manpages \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && yes | unminimize

USER rstudio

RUN Rscript -e ' \
  options(Ncpus = 32); \
  options(repos = "https://cran.ism.ac.jp"); \
  Sys.setenv(DOWNLOAD_STATIC_LIBV8=1); \
  install.packages(c( \
    "caret", \
    "doParallel", \
    "epitools", \
    "exactci", \
    "fable", \
    "factoextra", \
    "feasts", \
    "furrr", \
    "ggfortify", \
    "ggmosaic", \
    "glmnetUtils", \
    "gplots", \
    "h2o", \
    "igraph", \
    "keras", \
    "leaps", \
    "lintr", \
    "neuralnet", \
    "pastecs", \
    "prophet", \
    "PRROC", \
    "psych", \
    "proxy", \
    "randomForest", \
    "reticulate", \
    "rpart.plot", \
    "tsibble", \
    "urca", \
    "vcd" \
  )); \
  remotes::install_version("xgboost", version = "1.4.1.1"); \
  remotes::install_github(c("vqv/ggbiplot")); \
  reticulate::install_miniconda(); \
  keras::install_keras();'

WORKDIR /home/rstudio

USER root
