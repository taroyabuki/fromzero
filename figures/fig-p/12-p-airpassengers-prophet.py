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

from fbprophet import Prophet
my_prophet_model = Prophet(seasonality_mode='multiplicative')
my_prophet_model.fit(my_train)

tmp = my_prophet_model.predict(my_test)

fig = my_prophet_model.plot(tmp)
fig.axes[0].plot(my_train.ds, my_train.y)
fig.axes[0].plot(my_test.ds, my_test.y, color='red')

import matplotlib.pyplot as plt
plt.savefig('12-p-airpassengers-prophet.pdf')
