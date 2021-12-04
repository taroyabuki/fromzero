import pandas as pd
import statsmodels.api as sm
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import cross_val_score, LeaveOneOut
from sklearn.neighbors import KNeighborsRegressor

my_data = sm.datasets.get_rdataset('cars', 'datasets').data
X, y = my_data[['speed']], my_data['dist']

my_lm_scores = cross_val_score(
    LinearRegression(), X, y, cv=LeaveOneOut(), scoring='neg_mean_squared_error')

my_knn_socres = cross_val_score(
    KNeighborsRegressor(n_neighbors=5), X, y, cv=LeaveOneOut(),
    scoring='neg_mean_squared_error')

my_df = pd.DataFrame({
    'lm': -my_lm_scores,
    'knn': -my_knn_socres})

my_df.boxplot().set_ylabel("$r^2$")

import matplotlib.pyplot as plt
plt.savefig('07-p-boxplot.pdf')
