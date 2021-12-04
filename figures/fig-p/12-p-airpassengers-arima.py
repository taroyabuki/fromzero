import matplotlib.pyplot as plt
from pmdarima.datasets import airpassengers
my_data = airpassengers.load_airpassengers()

n = len(my_data)
k = 108

import pandas as pd
my_ds = pd.date_range(
    start='1949/01/01',
    end='1960/12/01',
    freq='MS')
my_df = pd.DataFrame({
    'ds': my_ds,
    'x': range(n),
    'y': my_data},
    index=my_ds)

my_train = my_df[        :k]
my_test  = my_df[-(n - k): ]

import pmdarima as pm
my_arima_model = pm.auto_arima(my_train.y, m=12, trace=True)

y_, my_ci = my_arima_model.predict(len(my_test),         # 期間はテストデータと同じ．
                                   alpha=0.05,           # 有意水準（デフォルト）
                                   return_conf_int=True) # 信頼区間を求める．
tmp = pd.DataFrame({'y': y_,
                    'Lo': my_ci[:, 0],
                    'Hi': my_ci[:, 1]},
                   index=my_test.index)

plt.plot(my_train.y, label='train')
plt.plot(my_test.y,  label='test')
plt.plot(tmp.y,      label='model')
plt.fill_between(tmp.index,
                 tmp.Lo,
                 tmp.Hi,
                 alpha=0.25)
plt.legend(loc='upper left')

plt.savefig('12-p-airpassengers-arima.pdf')
