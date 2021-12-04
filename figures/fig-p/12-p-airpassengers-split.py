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
y = my_test.y

import matplotlib.pyplot as plt
plt.plot(my_train.y, label='train')
plt.plot(my_test.y,  label='test')
plt.legend()
plt.savefig('12-p-airpassengers-split.pdf')
