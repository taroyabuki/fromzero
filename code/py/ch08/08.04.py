## 8.4 入力変数の数とモデルの良さ

import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import cross_val_score, LeaveOneOut

my_url = ('https://raw.githubusercontent.com/taroyabuki'
          '/fromzero/master/data/wine.csv')
my_data = pd.read_csv(my_url)

n = len(my_data)
my_data2 = my_data.assign(v1=[i % 2 for i in range(n)],
                          v2=[i % 3 for i in range(n)])
my_data2.head()
#>    LPRICE2  WRAIN  DEGREES  HRAIN  TIME_SV  v1  v2
#> 0 -0.99868    600  17.1167    160       31   0   0
#> 1 -0.45440    690  16.7333     80       30   1   1
#> 2 -0.80796    502  17.1500    130       28   0   2
#> 3 -1.50926    420  16.1333    110       26   1   0
#> 4 -1.71655    582  16.4167    187       25   0   1

X, y = my_data2.drop(columns=['LPRICE2']), my_data2['LPRICE2']
my_model2 = LinearRegression().fit(X, y)

y_ = my_model2.predict(X)
mean_squared_error(y_, y)**0.5
#> 0.2562120047505748 # RMSE（訓練）

my_scores = cross_val_score(my_model2, X, y,
                            cv=LeaveOneOut(),
                            scoring='neg_mean_squared_error')
(-my_scores.mean())**0.5
#> 0.3569918035928941 # RMSE（検証）
