## 8.7 ニューラルネットワーク

### 8.7.1 ニューラルネットワークとは何か

import matplotlib.pyplot as plt
import numpy as np
x = np.linspace(-6, 6, 100)
y = 1 / (1 + np.exp(-x))
plt.plot(x, y)

### 8.7.2 ニューラルネットワークの訓練

import pandas as pd
import warnings
from sklearn.exceptions import ConvergenceWarning
from sklearn.neural_network import MLPRegressor
from sklearn.model_selection import cross_val_score, GridSearchCV, LeaveOneOut
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

my_url = ('https://raw.githubusercontent.com/taroyabuki'
          '/fromzero/master/data/wine.csv')
my_data = pd.read_csv(my_url)
X, y = my_data.drop(columns=['LPRICE2']), my_data['LPRICE2']

warnings.simplefilter("ignore", ConvergenceWarning)  # これ以降，警告を表示しない．
my_pipeline = Pipeline([('sc', StandardScaler()),    # 標準化
                        ('mlp', MLPRegressor())])    # ニューラルネットワーク
my_pipeline.fit(X, y)                                # 訓練

my_scores = cross_val_score(my_pipeline, X, y, cv=LeaveOneOut(),
                            scoring='neg_mean_squared_error')
warnings.simplefilter("default", ConvergenceWarning) # これ以降，警告を表示する．

(-my_scores.mean())**0.5
#> 0.41735891601426384

### 8.7.3 ニューラルネットワークのチューニング

my_pipeline = Pipeline([
    ('sc', StandardScaler()),
    ('mlp', MLPRegressor(tol=1e-5,         # 改善したと見なす基準
                         max_iter=5000))]) # 改善しなくなるまでの反復数
my_layers = (1, 3, 5,                                         # 隠れ層1層の場合
             (1, 1), (3, 1), (5, 1), (1, 2), (3, 2), (5, 2))  # 隠れ層2層の場合
my_params = {'mlp__hidden_layer_sizes': my_layers}
my_search = GridSearchCV(estimator=my_pipeline,
                         param_grid=my_params,
                         cv=LeaveOneOut(),
                         scoring='neg_mean_squared_error',
                         n_jobs=-1).fit(X, y)
my_model = my_search.best_estimator_ # 最良モデル

my_search.best_params_               # 最良パラメータ
#> {'mlp__hidden_layer_sizes': 5}

(-my_search.best_score_)**0.5
#> 0.3759690731968538
