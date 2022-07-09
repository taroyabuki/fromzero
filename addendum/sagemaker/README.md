# Amazon SageMaker Studio Lab

無料の[Amazon SageMaker Studio Lab](https://studiolab.sagemaker.aws/)（以下，Studio Lab）で本書のコードを動かすための環境を作ります（GPU動作確認済）．Studio Labの概要は，[Amazon SageMaker Studio Lab入門](https://atmarkit.itmedia.co.jp/ait/subtop/features/di/sagemakerstudiolab_index.html)を参照してください．

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

Rのためのノートブックは[fromzero/code/R-notebook](/code/R-notebook)，Pythonのためのノードブックは[fromzero/code/Python-notebook](/code/Python-notebook)にあります．

ノートブックのファイル（.ipynb）をダブルクリックするとカーネル選択のダイアログが出るので，Rの場合はsage-r:R，Pythonの場合はsage-python:Pythonを選択してください．

補足：Jupyter Notebook（Python）の出力を本書と同じにするためには，最初に次のコードを実行してください．54頁の脚註24のようにしてもかまいません．

```python
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = "all"
```

## 仮想環境の削除

```bash
# Rの場合
conda remove -n sage-r --all -y

# Pythonの場合
conda remove -n sage-python --all -y
```

すべてを削除してやり直す方法は，[Amazon SageMaker Developer Guide](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lab-use-manage.html#:~:text=Start%20runtime.-,Reset%20environment,-To%20remove%20all)に掲載されています．

## 補足

環境構築に使った.ymlは次のように作成しました（このコードを実行する必要はありません）．

```bash
# Rの場合
conda create -y -n sage-r python=3.8.8
conda activate sage-r

conda install -y -c conda-forge \
  r-caret \
  r-doparallel \
  r-exactci \
  r-fable \
  r-factoextra \
  r-feasts \
  r-furrr \
  r-ggfortify \
  r-ggmosaic \
  r-glmnetutils \
  r-h2o==3.34.0.3 \
  r-igraph \
  r-irkernel \
  r-keras \
  r-neuralnet \
  r-pastecs \
  r-prophet \
  r-prroc \
  r-psych \
  r-randomforest \
  r-remotes \
  r-rpart.plot \
  r-tidyverse \
  r-urca \
  r-vcd \
  r-xgboost==1.4.1

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
