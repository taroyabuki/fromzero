import numpy as np
import pandas as pd
import statsmodels.api as sm
my_data = sm.datasets.get_rdataset('cars', 'datasets').data

my_idx = [1, 10, 26, 33, 38, 43]
my_sample = my_data.iloc[my_idx, ]
X, y = my_sample[['speed']], my_sample['dist']

from sklearn.preprocessing import PolynomialFeatures
d = 5
X5 = PolynomialFeatures(d).fit_transform(X) # Xの1乗から5乗の変数

from sklearn.linear_model import LinearRegression
my_model = LinearRegression()
my_model.fit(X5, y)

tmp = pd.DataFrame({'speed': np.linspace(min(my_data.speed),
                                         max(my_data.speed),
                                         100)})
X5 = PolynomialFeatures(d).fit_transform(tmp)
tmp['model'] = my_model.predict(X5)

my_sample = my_sample.assign(sample=y)
my_df = pd.concat([my_data, my_sample, tmp])
my_df.plot(x='speed', style=['o', 'o', '-'], ylim=(0, 130))

import matplotlib.pyplot as plt
plt.savefig('07-p-polynomial.pdf')
