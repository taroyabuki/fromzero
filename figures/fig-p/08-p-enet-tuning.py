import numpy as np
import pandas as pd
from sklearn.linear_model import ElasticNet
from sklearn.model_selection import GridSearchCV, LeaveOneOut
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

my_url = ('https://raw.githubusercontent.com/taroyabuki/' +
          'fromzero/master/data/wine.csv')
my_data = pd.read_csv(my_url)
X, y = my_data.drop(columns=['LPRICE2']), my_data['LPRICE2']

As = np.linspace(0, 0.1, 21)
Bs = np.linspace(0, 0.1,  6)

my_pipeline = Pipeline([('sc', StandardScaler()),
                        ('enet', ElasticNet())])
my_search = GridSearchCV(
    estimator=my_pipeline,
    param_grid={'enet__alpha': As, 'enet__l1_ratio': Bs},
    cv=LeaveOneOut(),
    scoring='neg_mean_squared_error',
    n_jobs=-1).fit(X, y)

tmp = my_search.cv_results_                # チューニング結果の詳細
my_scores = (-tmp['mean_test_score'])**0.5 # MSEからRMSEへの変換

my_results = pd.DataFrame(tmp['params']).assign(RMSE=my_scores).pivot(
    index='enet__alpha',
    columns='enet__l1_ratio',
    values='RMSE')

my_results.plot(style='o-', xlabel='A ( = alpha)', ylabel='RMSE').legend(
    title='B ( = l1_ratio)')

import matplotlib.pyplot as plt
plt.savefig('08-p-enet-tuning.pdf')
