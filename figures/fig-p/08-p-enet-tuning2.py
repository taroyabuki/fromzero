import itertools
import numpy as np
import pandas as pd
from pandarallel import pandarallel
from scipy.stats import zscore
from sklearn.linear_model import ElasticNet
from sklearn.metrics import mean_squared_error
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

my_url = ('https://raw.githubusercontent.com'
          '/taroyabuki/fromzero/master/data/wine.csv')
my_data = pd.read_csv(my_url)
X, y = my_data.drop(columns=['LPRICE2']), my_data['LPRICE2']

def my_loocv(A, B):
    def my_predict(id):
        my_train = my_data.drop([id])
        my_valid = my_data.take([id])
        X, y = my_train.drop(columns=['LPRICE2']), my_train.LPRICE2
        u = y.mean()
        s = y.std(ddof=0)
        my_model = Pipeline([
            ('sc', StandardScaler()),
            ('enet', ElasticNet(alpha=A, l1_ratio=B))]).fit(X, zscore(y))
        X = my_valid.drop(columns=['LPRICE2'])
        return (my_model.predict(X) * s + u)[0]

    y_ = [my_predict(id) for id in range(len(my_data))]
    rmse = mean_squared_error(y_, y)**0.5
    return pd.Series([A, B, rmse], index=['A', 'B', 'RMSE'])

As = np.linspace(0, 0.1, 21)
Bs = np.linspace(0, 0.1,  6)
my_plan = pd.DataFrame(itertools.product(As, Bs), columns=['A', 'B'])

pandarallel.initialize()
my_results = my_plan.parallel_apply(lambda row: my_loocv(*row), axis=1)

print(my_results[my_results.RMSE == my_results.RMSE.min()])

my_results.pivot(index='A', columns='B', values='RMSE').plot(
    style='o-', xlabel='A ( = alpha)', ylabel='RMSE').legend(
    title='B ( = l1_ratio)')

import matplotlib.pyplot as plt
plt.savefig('08-p-enet-tuning2.pdf')
