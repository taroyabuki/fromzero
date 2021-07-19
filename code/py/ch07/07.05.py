## 7.5 K最近傍法

### 7.5.1 K最近傍法とは何か

### 7.5.2 K最近傍法の実践

# 準備
import numpy as np
import pandas as pd
import statsmodels.api as sm
from sklearn.neighbors import KNeighborsRegressor

my_data = sm.datasets.get_rdataset('cars', 'datasets').data
X, y = my_data[['speed']], my_data['dist']

# 訓練
my_model = KNeighborsRegressor()
my_model.fit(X, y)

# 可視化の準備
tmp = pd.DataFrame({'speed': np.linspace(min(my_data.speed),
                                         max(my_data.speed),
                                         100)})
tmp['model'] = my_model.predict(tmp)

pd.concat([my_data, tmp]).plot(
    x='speed', style=['o', '-'])

y_ = my_model.predict(X)

((y - y_)**2).mean()**0.5
#> 13.087184571174962 # RMSE

my_model.score(X, y)
#> 0.7368165812204317 # 決定係数1

np.corrcoef(y, y_)[0, 1]**2
#> 0.7380949412509705 # 決定係数6
