## 8.2 重回帰分析

import numpy as np
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import cross_val_score, LeaveOneOut

my_url = ('https://raw.githubusercontent.com/taroyabuki'
          '/fromzero/master/data/wine.csv')
my_data = pd.read_csv(my_url)
X, y = my_data.drop(columns=['LPRICE2']), my_data['LPRICE2']

my_model = LinearRegression().fit(X, y)

my_model.intercept_
#> -12.145333576510417

pd.Series(my_model.coef_,
          index=X.columns)
#> WRAIN      0.001167
#> DEGREES    0.616392
#> HRAIN     -0.003861
#> TIME_SV    0.023847
#> dtype: float64

my_test = [[500, 17, 120, 2]]
my_model.predict(my_test)
#> array([-1.49884253])

y_ = my_model.predict(X)

mean_squared_error(y_, y)**0.5
#> 0.2586166620130621 # RMSE（訓練）

my_model.score(X, y)
#> 0.8275277990052154 # 決定係数1

np.corrcoef(y, y_)[0, 1]**2
#> 0.8275277990052158 # 決定係数6

my_scores = cross_val_score(my_model, X, y,
                            cv=LeaveOneOut(),
                            scoring='neg_mean_squared_error')
(-my_scores.mean())**0.5
#> 0.32300426518411957 # RMSE（検証）

### 8.2.1 補足：行列計算による再現

import numpy as np
M = np.matrix(X.assign(b0=1))
b = np.linalg.pinv(M) @ y
pd.Series(b,
    index=list(X.columns) + ['b0'])
#> WRAIN       0.001167
#> DEGREES     0.616392
#> HRAIN      -0.003861
#> TIME_SV     0.023847
#> b0        -12.145334
#> dtype: float64
