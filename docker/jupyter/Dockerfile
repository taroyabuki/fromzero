FROM jupyter/datascience-notebook:python-3.8.8

# pystan==2.18.0.0 for fbprophet
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
  pystan==2.18.0.0 \
  tensorflow \
  xgboost

RUN pip install fbprophet

RUN Rscript -e ' \
  Sys.setenv(DOWNLOAD_STATIC_LIBV8=1); \
  install.packages("pak", repos = "https://r-lib.github.io/p/pak/dev/"); \
  pak::pkg_install(c( \
    "doParallel", \
    "e1071", \
    "epitools", \
    "exactci", \
    "fable", \
    "factoextra", \
    "feasts", \
    "furrr", \
    "ggrepel", \
    "gridExtra", \
    "ggfortify", \
    "glmnetUtils", \
    "gplots", \
    "h2o", \
    "igraph", \
    "neuralnet", \
    "PRROC", \
    "pastecs", \
    "prophet", \
    "psych", \
    "pryr", \
    "rpart.plot", \
    "tsibble", \
    "vcd", \
    "xgboost", \
    "haleyjeppson/ggmosaic", \
    "rstudio/keras", \
    "vqv/ggbiplot" \
  ));'

RUN mkdir -p /home/jovyan/.ipython/profile_default && echo "c.InteractiveShell.ast_node_interactivity = 'all'" > /home/jovyan/.ipython/profile_default/ipython_config.py

USER root

RUN rm /etc/dpkg/dpkg.cfg.d/excludes \
  && apt-get update \
  && apt-get install -y \
    default-jdk \
    dnsutils \
    graphviz \
    iputils-ping \
    less \
    net-tools \
  && apt-get --reinstall install -y man-db coreutils manpages \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && bash -c 'yes | unminimize' # ad hoc

WORKDIR /home/jovyan
