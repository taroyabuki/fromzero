import pandas as pd
import statsmodels.api as sm
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

my_results.plot(x='n_neighbors',
                style='o-',
                ylabel='RMSE')

import matplotlib.pyplot as plt
plt.savefig('07-p-tuning.pdf')
