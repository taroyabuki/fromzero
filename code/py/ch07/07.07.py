## 7.7 パラメータチューニング

import pandas as pd
import statsmodels.api as sm
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import GridSearchCV, LeaveOneOut
from sklearn.neighbors import KNeighborsRegressor

my_data = sm.datasets.get_rdataset('cars', 'datasets').data
X, y = my_data[['speed']], my_data['dist']

my_params = {'n_neighbors': range(1, 16)} # 探索範囲（1以上16未満の整数）

my_search = GridSearchCV(estimator=KNeighborsRegressor(),
                         param_grid=my_params,
                         cv=LeaveOneOut(),
                         scoring='neg_mean_squared_error')
my_search.fit(X, y)

tmp = my_search.cv_results_                # チューニングの詳細
my_scores = (-tmp['mean_test_score'])**0.5 # RMSE
my_results = pd.DataFrame(tmp['params']).assign(validation=my_scores)

my_results.head()
#>    n_neighbors  validation
#> 0            1   20.089798
#> 1            2   17.577685
#> 2            3   16.348836
#> 3            4   16.198804
#> 4            5   16.073083

my_results.plot(x='n_neighbors',
                style='o-',
                ylabel='RMSE')

my_search.best_params_
#> {'n_neighbors': 5}

(-my_search.best_score_)**0.5
#> 16.07308308943869

my_model = my_search.best_estimator_
y_ = my_model.predict(X)
mean_squared_error(y_, y)**0.5
#> 13.087184571174962

### 7.7.1 補足：ハイパーパラメータとRMSE（訓練）

import pandas as pd
import statsmodels.api as sm
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import cross_val_score, LeaveOneOut
from sklearn.neighbors import KNeighborsRegressor

my_data = sm.datasets.get_rdataset('cars', 'datasets').data
X, y = my_data[['speed']], my_data['dist']

def my_loocv(k):
    my_model = KNeighborsRegressor(n_neighbors=k)
    my_scores = cross_val_score(estimator=my_model, X=X, y=y,
                                cv=LeaveOneOut(),
                                scoring='neg_mean_squared_error')
    y_ = my_model.fit(X, y).predict(X)
    return pd.Series([k,
                      (-my_scores.mean())**0.5,        # RMSE（検証）
                      mean_squared_error(y_, y)**0.5], # RMSE（訓練）
                     index=['n_neighbors', 'validation', 'training'])

my_results = pd.Series(range(1, 16)).apply(my_loocv)

my_results.plot(x='n_neighbors',
                style='o-',
                ylabel='RMSE')
