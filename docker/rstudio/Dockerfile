FROM rocker/tidyverse

USER rstudio

RUN Rscript -e ' \
  install.packages("pak", repos = "https://r-lib.github.io/p/pak/dev/"); \
  pak::pkg_install(c( \
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
    "vcd", \
    "xgboost", \
    "haleyjeppson/ggmosaic", \
    "rstudio/keras", \
    "vqv/ggbiplot" \
  )); \
  reticulate::install_miniconda(); \
  keras::install_keras();'

USER root

RUN rm /etc/dpkg/dpkg.cfg.d/excludes \
  && apt-get update \
  && apt-get install -y \
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

WORKDIR /home/rstudio
