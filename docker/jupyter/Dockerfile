FROM jupyter/datascience-notebook:python-3.8.8

USER root

RUN rm /etc/dpkg/dpkg.cfg.d/excludes \
  && sed -i -e 's%http://[^ ]\+%mirror://mirrors.ubuntu.com/mirrors.txt%g' /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    default-jdk \
    dnsutils \
    graphviz \
    iputils-ping \
    less \
    net-tools \
  && apt-get --reinstall install -y man-db coreutils manpages \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && echo y | unminimize

USER jovyan

# pystan==2.* for fbprophet
RUN pip install \
  graphviz \
  h2o \
  japanize_matplotlib \
  keras \
  lxml \
  pandarallel \
  pca \
  pmdarima \
  pycodestyle \
  pystan==2.* \
  tensorflow \
  xgboost

RUN pip install fbprophet

RUN mkdir -p /home/jovyan/.ipython/profile_default && echo "c.InteractiveShell.ast_node_interactivity = 'all'" > /home/jovyan/.ipython/profile_default/ipython_config.py

RUN Rscript -e ' \
  options(Ncpus = 32); \
  options(repos = "https://cran.ism.ac.jp"); \
  Sys.setenv(DOWNLOAD_STATIC_LIBV8=1); \
  install.packages(c( \
    "doParallel", \
    "e1071", \
    "epitools", \
    "exactci", \
    "fable", \
    "factoextra", \
    "feasts", \
    "furrr", \
    "ggfortify", \
    "ggmosaic", \
    "gplots", \
    "glmnetUtils", \
    "h2o", \
    "igraph", \
    "keras", \
    "leaps", \
    "lintr", \
    "neuralnet", \
    "pastecs", \
    "prophet", \
    "proxy", \
    "PRROC", \
    "psych", \
    "rpart.plot", \
    "tsibble", \
    "vcd" \
  )); \
  remotes::install_version("xgboost", version = "1.4.1.1"); \
  remotes::install_github(c("vqv/ggbiplot"));'

WORKDIR /home/jovyan

USER root
