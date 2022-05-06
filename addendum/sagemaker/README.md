# Amazon SageMaker Studio Lab

無料のAmazon SageMaker Studio Lab（以下，Studio Lab）で本書のコードを動かすための環境を作ります（GPU動作確認済）．Studio Labの概要は，[Amazon SageMaker Studio Lab入門](https://atmarkit.itmedia.co.jp/ait/subtop/features/di/sagemakerstudiolab_index.html)を参照してください．

TerminalでGitHubリポジトリをクローンします．

```bash
git clone https://github.com/taroyabuki/fromzero.git
```

## 仮想環境の構築

```bash
# Rの場合
conda env create --file fromzero/addendum/sagemaker/sage-r.yml

# Pythonの場合
conda env create --file fromzero/addendum/sagemaker/sage-python.yml
```

## Jupyter Notebookの利用

画面左のファイルブラウザーがあります．

Rのためのノートブックは[fromzero/code/R-notebook](fromzero/code/R-notebook)，Pythonのためのノードブックは[fromzero/code/Python-notebook](fromzero/code/Python-notebook)にあります．

ノートブックのファイル（.ipynb）をダブルクリックするとカーネル選択のダイアログが出るので，Rの場合はsage-r:R，Pythonの場合はsage-python:Pythonを選択してください．

## 仮想環境の削除

```bash
# Rの場合
conda remove -n sage-r --all -y

# Pythonの場合
conda remove -n sage-python --all -y
```

## 補足

環境構築に使った.ymlは次のように作成しました（このコードを実行する必要はありません）．

```bash
# Rの場合
conda create -y -n sage-r python=3.8.8
conda activate sage-r

conda install -y -c conda-forge r-caret
conda install -y -c conda-forge r-doparallel
conda install -y -c conda-forge r-exactci
conda install -y -c conda-forge r-fable
conda install -y -c conda-forge r-factoextra
conda install -y -c conda-forge r-feasts
conda install -y -c conda-forge r-furrr
conda install -y -c conda-forge r-ggfortify
conda install -y -c conda-forge r-ggmosaic
conda install -y -c conda-forge r-glmnetutils
conda install -y -c conda-forge r-h2o==3.34.0.3
conda install -y -c conda-forge r-igraph
conda install -y -c conda-forge r-irkernel
conda install -y -c conda-forge r-keras
conda install -y -c conda-forge r-neuralnet
conda install -y -c conda-forge r-pastecs
conda install -y -c conda-forge r-prophet
conda install -y -c conda-forge r-prroc
conda install -y -c conda-forge r-psych
conda install -y -c conda-forge r-randomforest
conda install -y -c conda-forge r-remotes
conda install -y -c conda-forge r-rpart.plot
conda install -y -c conda-forge r-tidyverse
conda install -y -c conda-forge r-urca
conda install -y -c conda-forge r-vcd
conda install -y -c conda-forge r-xgboost==1.4.1
conda install -y -c bioconda r-ggbiplot

Rscript -e 'keras::install_keras()'

conda env export -n sage-r > sage-r.yml
```

```bash
# Pythonの場合
conda create -y -n sage-python python=3.8.8
conda activate sage-python

conda install -y \
  fbprophet \
  ipykernel \
  keras \
  lxml \
  matplotlib \
  pandarallel \
  pmdarima \
  python-graphviz \
  seaborn \
  scikit-learn \
  scipy==1.6.3 \
  statsmodels \
  tensorflow-gpu \
  xgboost==1.5.1

conda install -y -c anaconda h2o h2o-py

pip install pca

conda env export -n sage-python > sage-python.yml
```
