FROM amoselb/rstudio-m1

USER root

RUN rm /etc/dpkg/dpkg.cfg.d/excludes \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    dnsutils \
    iputils-ping \
    less \
    libgit2-dev \
    libglpk-dev \
    libnode64 \
    libtbb2 \
    net-tools \
    vim-tiny \
  && apt-get --reinstall install -y man-db coreutils manpages \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN Rscript -e ' \
  options(Ncpus = 8); \
  options(repos = "https://cran.ism.ac.jp"); \
  install.packages(c("https://cran.r-project.org/bin/macosx/big-sur-arm64/contrib/4.1/RcppEigen_0.3.3.9.1.tgz"), repos = NULL); \
  install.packages(c( \
    "caret", \
    "doParallel", \
    "epitools", \
    "exactci", \
    "factoextra", \
    "fable", \
    "feasts", \
    "furrr", \
    "ggfortify", \
    "ggmosaic", \
    "glmnetUtils", \
    "gplots", \
    "igraph", \
    "keras", \
    "leaps", \
    "neuralnet", \
    "pastecs", \
    "prophet", \
    "proxy", \
    "PRROC", \
    "psych", \
    "Rcpp", \
    "randomForest", \
    "remotes", \
    "reticulate", \
    "rpart.plot", \
    "tsibble", \
    "urca", \
    "vcd" \
  )); \
  remotes::install_version("xgboost", version = "1.4.1.1"); \
  remotes::install_github(c("vqv/ggbiplot"));'

WORKDIR /home/rstudio
