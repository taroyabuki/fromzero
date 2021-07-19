## 11.1 Kerasによる回帰

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from keras import activations, callbacks, layers, models
from sklearn.preprocessing import StandardScaler
from sklearn.utils import shuffle

my_url = ('https://raw.githubusercontent.com/taroyabuki'
          '/fromzero/master/data/wine.csv')
tmp = pd.read_csv(my_url)

my_data = shuffle(tmp)

my_scaler = StandardScaler()
X = my_scaler.fit_transform(
    my_data.drop(columns=['LPRICE2']))
y = my_data['LPRICE2']

x = np.linspace(-3, 3, 100)
plt.plot(x, activations.relu(x))
plt.xlabel('x')
plt.ylabel('ReLU(x)')

my_model = models.Sequential()
my_model.add(layers.Dense(units=3, activation='relu', input_shape=[4]))
my_model.add(layers.Dense(units=1))

my_model.summary() # ネットワークの概要
#> Model: "sequential"
#> _________________________________________________________________
#> Layer (type)                 Output Shape              Param #
#> =================================================================
#> dense (Dense)                (None, 3)                 15
#> _________________________________________________________________
#> dense_1 (Dense)              (None, 1)                 4
#> =================================================================
#> Total params: 19
#> Trainable params: 19
#> Non-trainable params: 0

my_model.compile(
    loss='mse',
    optimizer='rmsprop')

my_cb = callbacks.EarlyStopping(
    patience=20,
    restore_best_weights=True)

my_history = my_model.fit(
    x=X,
    y=y,
    validation_split=0.25,
    batch_size=10,
    epochs=500,
    callbacks=[my_cb],
    verbose=0)

tmp = pd.DataFrame(my_history.history)
tmp.plot(xlabel='epoch')

tmp.iloc[-1, ]
#> loss        0.192743
#> val_loss    0.342249
#> Name: 499, dtype: float64

y_ = my_model.predict(X)
((y_.ravel() - y)**2).mean()
#> 0.23050613964540986
