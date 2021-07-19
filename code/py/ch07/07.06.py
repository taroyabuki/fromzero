## 7.6 検証

### 7.6.1 訓練データ・検証データ・テストデータ

### 7.6.2 検証とは何か

### 7.6.3 検証の実践

import statsmodels.api as sm
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import cross_val_score

# データの準備
my_data = sm.datasets.get_rdataset('cars', 'datasets').data
X, y = my_data[['speed']], my_data['dist']

# モデルの指定
my_model = LinearRegression()

# 検証（5分割交差検証）
my_scores = cross_val_score(my_model, X, y)

# 5個の決定係数1を得る．
my_scores
#> array([-0.25789256, -0.21421069, -0.30902773, -0.27346232,  0.02312918])

# 平均を決定係数1（検証）とする．
my_scores.mean()
#> -0.20629282165364665

my_scores = cross_val_score(my_model, X, y,
                            scoring='neg_root_mean_squared_error')
-my_scores.mean()
#> 15.58402474583013 # RMSE（検証）

### 7.6.4 検証の並列化

### 7.6.5 指標のまとめ

#### 7.6.5.1 準備

import numpy as np
import statsmodels.api as sm
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.model_selection import cross_val_score, LeaveOneOut

my_data = sm.datasets.get_rdataset('cars', 'datasets').data
X, y = my_data[['speed']], my_data['dist']
my_model = LinearRegression().fit(X, y)
y_ = my_model.predict(X)

#### 7.6.5.2 当てはまりの良さの指標

# RMSE（訓練）
mean_squared_error(y, y_)**0.5
#> 15.068855995791381

# 決定係数1（訓練）
my_model.score(X, y)
# あるいは
r2_score(y_true=y, y_pred=y_)
#> 0.6510793807582509

# 決定係数6（訓練）
np.corrcoef(y, y_)[0, 1]**2
#> 0.6510793807582511

#### 7.6.5.3 予測性能の指標（簡単に求められるもの）

my_scores = cross_val_score(my_model, X, y,
                            scoring='neg_root_mean_squared_error')
-my_scores.mean()
#> 15.301860331378464  # RMSE（検証）

my_scores = cross_val_score(my_model, X, y, scoring='r2') # scoring='r2'は省略可
my_scores.mean()
#> 0.49061365458235245 # 決定係数1（検証）

#### 7.6.5.4 予測性能の指標（RとPythonで同じ結果を得る）

# 方法1
my_scores1 = cross_val_score(my_model, X, y, cv=LeaveOneOut(),
                             scoring='neg_mean_squared_error')
(-my_scores1.mean())**0.5
#> 15.697306009399101

# 方法2
my_scores2 = cross_val_score(my_model, X, y, cv=LeaveOneOut(),
                             scoring='neg_root_mean_squared_error')
(my_scores2**2).mean()**0.5
#> 15.697306009399101

-my_scores2.mean()
#> 12.059178648637483

### 7.6.6 補足：検証による手法の比較

import pandas as pd
import statsmodels.api as sm
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import cross_val_score, LeaveOneOut
from sklearn.neighbors import KNeighborsRegressor

my_data = sm.datasets.get_rdataset('cars', 'datasets').data
X, y = my_data[['speed']], my_data['dist']

my_lm_scores = cross_val_score(
    LinearRegression(),
    X, y, cv=LeaveOneOut(), scoring='neg_mean_squared_error')

my_knn_socres = cross_val_score(
    KNeighborsRegressor(n_neighbors=5),
    X, y, cv=LeaveOneOut(), scoring='neg_mean_squared_error')

(-my_lm_scores.mean())**0.5
#> 15.697306009399101 # 線形回帰分析

(-my_knn_socres.mean())**0.5
#> 16.07308308943869 # K最近傍法

my_df = pd.DataFrame({
    'lm': -my_lm_scores,
    'knn': -my_knn_socres})
my_df.head()
#>            lm     knn
#> 0   18.913720  108.16
#> 1  179.215044    0.64
#> 2   41.034336   64.00
#> 3  168.490212  184.96
#> 4    5.085308    0.00

my_df.boxplot().set_ylabel("$r^2$")

from statsmodels.stats.weightstats import DescrStatsW
d = DescrStatsW(my_df.lm - my_df.knn)
d.ttest_mean()[1] # p値
#> 0.6952755720536115

d.tconfint_mean(alpha=0.05, alternative='two-sided') # 信頼区間
#> (-72.8275283312228, 48.95036023665703)
