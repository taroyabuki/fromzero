## 12.2 時系列データの予測

### 12.2.1 データの準備

import matplotlib.pyplot as plt
import pandas as pd
from pmdarima.datasets import airpassengers
from sklearn.metrics import mean_squared_error

my_data = airpassengers.load_airpassengers()

n = len(my_data) # データ数（144）
k = 108          # 訓練データ数

my_ds = pd.date_range(
    start='1949/01/01',
    end='1960/12/01',
    freq='MS')
my_df = pd.DataFrame({
    'ds': my_ds,
    'x': range(n),
    'y': my_data},
    index=my_ds)
my_df.head()
#>                    ds  x      y
#> 1949-01-01 1949-01-01  0  112.0
#> 1949-02-01 1949-02-01  1  118.0
#> 1949-03-01 1949-03-01  2  132.0
#> 1949-04-01 1949-04-01  3  129.0
#> 1949-05-01 1949-05-01  4  121.0

my_train = my_df[        :k]
my_test  = my_df[-(n - k): ]
y = my_test.y

plt.plot(my_train.y, label='train')
plt.plot(my_test.y,  label='test')
plt.legend()

### 12.2.2 線形回帰分析による時系列予測

from sklearn.linear_model import LinearRegression

my_lm_model = LinearRegression()
my_lm_model.fit(my_train[['x']], my_train.y)

X = my_test[['x']]
y_ = my_lm_model.predict(X)
mean_squared_error(y, y_)**0.5 # RMSE（テスト）
#> 70.63707081783771

y_ = my_lm_model.predict(my_df[['x']])
tmp = pd.DataFrame(y_,
                   index=my_df.index)
plt.plot(my_train.y, label='train')
plt.plot(my_test.y,  label='test')
plt.plot(tmp, label='model')
plt.legend()

### 12.2.3 SARIMAによる時系列予測

#### 12.2.3.1 モデルの構築

import pmdarima as pm
my_arima_model = pm.auto_arima(my_train.y, m=12, trace=True)
#> （省略）
#> Best model:  ARIMA(1,1,0)(0,1,0)[12]
#> Total fit time: 0.838 seconds

#### 12.2.3.2 予測

y_, my_ci = my_arima_model.predict(len(my_test),         # 期間はテストデータと同じ．
                                   alpha=0.05,           # 有意水準（デフォルト）
                                   return_conf_int=True) # 信頼区間を求める．
tmp = pd.DataFrame({'y': y_,
                    'Lo': my_ci[:, 0],
                    'Hi': my_ci[:, 1]},
                   index=my_test.index)
tmp.head()
#>                      y          Lo          Hi
#> 1958-01-01  345.964471  327.088699  364.840243
#> 1958-02-01  331.731920  308.036230  355.427610
#> 1958-03-01  386.787992  358.515741  415.060244
#> 1958-04-01  378.774472  346.695454  410.853490
#> 1958-05-01  385.777732  350.270765  421.284700

mean_squared_error(y, y_)**0.5
#> 22.132236727738697

plt.plot(my_train.y, label='train')
plt.plot(my_test.y,  label='test')
plt.plot(tmp.y,      label='model')
plt.fill_between(tmp.index,
                 tmp.Lo,
                 tmp.Hi,
                 alpha=0.25) # 不透明度
plt.legend(loc='upper left')

### 12.2.4 Prophetによる時系列予測

try:
  from prophet import Prophet
except ImportError:
  from fbprophet import Prophet
my_prophet_model = Prophet(seasonality_mode='multiplicative')
my_prophet_model.fit(my_train)

tmp = my_prophet_model.predict(my_test)
tmp[['ds', 'yhat', 'yhat_lower', 'yhat_upper']].head()
#>           ds        yhat  yhat_lower  yhat_upper
#> 0 1958-01-01  359.239305  350.910898  368.464588
#> 1 1958-02-01  350.690546  341.748862  359.964881
#> 2 1958-03-01  407.188556  398.483316  415.463759
#> 3 1958-04-01  398.481739  389.244105  406.742333
#> 4 1958-05-01  402.595604  393.721421  411.331761

y_ = tmp.yhat
mean_squared_error(y, y_)**0.5
#> 33.795549086036466

# my_prophet_model.plot(tmp) # 予測結果のみでよい場合

fig = my_prophet_model.plot(tmp)
fig.axes[0].plot(my_train.ds, my_train.y)
fig.axes[0].plot(my_test.ds, my_test.y, color='red')
