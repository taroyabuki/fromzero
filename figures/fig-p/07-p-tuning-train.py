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

import matplotlib.pyplot as plt
plt.savefig('07-p-tuning-train.pdf')
