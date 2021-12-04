## 7.3 回帰分析

### 7.3.1 回帰分析とは何か

### 7.3.2 線形単回帰分析

import seaborn as sns
import statsmodels.api as sm

my_data = sm.datasets.get_rdataset('cars', 'datasets').data
ax = sns.regplot(x='speed', y='dist', data=my_data)
ax.vlines(x=21.5, ymin=-5, ymax=67,   linestyles='dotted')
ax.hlines(y=67,   xmin=4,  xmax=21.5, linestyles='dotted')
ax.set_xlim(4, 25)
ax.set_ylim(-5, 125)

### 7.3.3 回帰分析の実践

#### 7.3.3.1 データの用意

import statsmodels.api as sm
my_data = sm.datasets.get_rdataset('cars', 'datasets').data
X, y = my_data[['speed']], my_data['dist']

#### 7.3.3.2 訓練

# モデルの指定
from sklearn.linear_model import LinearRegression
my_model = LinearRegression()

# 訓練（モデルをデータにフィットさせる．）
my_model.fit(X, y)

# まとめて実行してもよい．
# my_model = LinearRegression().fit(X, y)

my_model.intercept_, my_model.coef_
#> (-17.579094890510973,
#>  array([3.93240876]))

#### 7.3.3.3 予測

tmp = [[21.5]]
my_model.predict(tmp)
#> array([66.96769343])

#### 7.3.3.4 モデルの可視化

import numpy as np
import pandas as pd

tmp = pd.DataFrame({'speed': np.linspace(min(my_data.speed),
                                         max(my_data.speed),
                                         100)})
tmp['model'] = my_model.predict(tmp)

pd.concat([my_data, tmp]).plot(
    x='speed', style=['o', '-'])
