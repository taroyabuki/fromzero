## 9.5 欠損のあるデータでの学習

### 9.5.1 欠損のあるデータの準備

import numpy as np
import statsmodels.api as sm
import warnings
import xgboost
from sklearn import tree
from sklearn.impute import SimpleImputer
from sklearn.model_selection import cross_val_score, LeaveOneOut
from sklearn.pipeline import Pipeline

my_data = sm.datasets.get_rdataset('iris', 'datasets').data

n = len(my_data)
my_data['Petal.Length'] = [np.nan if i % 10 == 0 else
                           my_data['Petal.Length'][i] for i in range(n)]
my_data['Petal.Width']  = [np.nan if i % 10 == 1 else
                           my_data['Petal.Width'][i]  for i in range(n)]

my_data.describe() # countの値が135の変数に，150-135=15個の欠損がある．
#>        Sepal.Length  Sepal.Width  Petal.Length  Petal.Width
#> count    150.000000   150.000000    135.000000   135.000000
#> mean       5.843333     3.057333      3.751852     1.197037
# 以下省略

X, y = my_data.iloc[:, 0:4], my_data.Species

### 9.5.2 方針1：欠損を埋めて学習する．

my_pipeline = Pipeline([
    ('imputer', SimpleImputer(strategy='median')), # 欠損を中央値で埋める．
    ('tree', tree.DecisionTreeClassifier(random_state=0))])
my_scores = cross_val_score(my_pipeline, X, y, cv=LeaveOneOut(), n_jobs=-1)
my_scores.mean()
#> 0.9333333333333333

### 9.5.3 方針2：欠損があっても使える手法で学習する．

warnings.simplefilter('ignore')  # これ以降，警告を表示しない．
my_scores = cross_val_score(
    xgboost.XGBClassifier(eval_metric='mlogloss'), X, y, cv=5)
warnings.simplefilter('default') # これ以降，警告を表示する．

my_scores.mean()
#> 0.9666666666666668
