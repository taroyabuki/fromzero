# 準備
import statsmodels.api as sm
my_data = sm.datasets.get_rdataset('cars', 'datasets').data
X, y = my_data[['speed']], my_data['dist']

# 訓練
from sklearn.neighbors import KNeighborsRegressor
my_model = KNeighborsRegressor()
my_model.fit(X, y)

# 可視化の準備
import numpy as np
import pandas as pd
tmp = pd.DataFrame({'speed': np.linspace(min(my_data.speed),
                                         max(my_data.speed),
                                         num=100)})
tmp['model'] = my_model.predict(tmp)

pd.concat([my_data, tmp]).plot(
    x='speed', style=['o', '-'])
import matplotlib.pyplot as plt
plt.savefig('07-p-knn.pdf')
