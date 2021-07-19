## 7.4 当てはまりの良さの指標

### 7.4.1 RMSE

import pandas as pd
import statsmodels.api as sm
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score

my_data = sm.datasets.get_rdataset('cars', 'datasets').data
X, y = my_data[['speed']], my_data['dist']

my_model = LinearRegression()
my_model.fit(X, y)
y_ = my_model.predict(X)
my_data['y_'] = y_

pd.options.display.float_format = (
    '{:.2f}'.format)
my_data['residual'] = y - y_
my_data.head()
#>    speed  dist    y_  residual
#> 0      4     2 -1.85      3.85
#> 1      4    10 -1.85     11.85
#> 2      7     4  9.95     -5.95
#> 3      7    22  9.95     12.05
#> 4      8    16 13.88      2.12

ax = my_data.plot(x='speed', y='dist', style='o', legend=False)
my_data.plot(x='speed', y='y_', style='-', legend=False, ax=ax)
ax.vlines(x=X, ymin=y, ymax=y_, linestyles='dotted')

mean_squared_error(y, y_)**0.5
# あるいは
(my_data['residual']**2).mean()**0.5

#> 15.068855995791381

### 7.4.2 決定係数

my_model.score(X, y)
# あるいは
r2_score(y_true=y, y_pred=y_)
#> 0.6510793807582509

import numpy as np
np.corrcoef(y, y_)[0, 1]**2
#> 0.6510793807582511

my_test = my_data[:3]
X = my_test[['speed']]
y = my_test['dist']
y_ = my_model.predict(X)

my_model.score(X, y)
# あるいは
r2_score(y_true=y, y_pred=y_)
#> -4.498191310376778 # 決定係数1

np.corrcoef(y, y_)[0, 1]**2
#> 0.0769230769230769 # 決定係数6

### 7.4.3 当てはまりの良さの指標の問題点

import numpy as np
import pandas as pd
import statsmodels.api as sm
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures

my_data = sm.datasets.get_rdataset('cars', 'datasets').data

my_idx = [1, 10, 26, 33, 38, 43]
my_sample = my_data.iloc[my_idx, ]
X, y = my_sample[['speed']], my_sample['dist']

d = 5
X5 = PolynomialFeatures(d).fit_transform(X) # Xの1乗から5乗の変数

my_model = LinearRegression()
my_model.fit(X5, y)
y_ = my_model.predict(X5)

((y - y_)**2).mean()**0.5
#> 7.725744805546204e-07 # RMSE

my_model.score(X5, y)
#> 0.9999999999999989 # 決定係数1

np.corrcoef(y, y_)[0, 1]**2
#> 0.9999999999999991 # 決定係数6

tmp = pd.DataFrame({'speed': np.linspace(min(my_data.speed),
                                         max(my_data.speed),
                                         100)})
X5 = PolynomialFeatures(d).fit_transform(tmp)
tmp['model'] = my_model.predict(X5)

my_sample = my_sample.assign(sample=y)
my_df = pd.concat([my_data, my_sample, tmp])
my_df.plot(x='speed', style=['o', 'o', '-'], ylim=(0, 130))
