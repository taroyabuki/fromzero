import pandas as pd
import sklearn
from keras import callbacks, layers, models
from sklearn.preprocessing import StandardScaler

my_url = ('https://raw.githubusercontent.com'
          '/taroyabuki/fromzero/master/data/wine.csv')
tmp = pd.read_csv(my_url)

my_data = sklearn.utils.shuffle(tmp)

my_scaler = StandardScaler()
X = my_scaler.fit_transform(
    my_data.drop(columns=['LPRICE2']))
y = my_data['LPRICE2']

my_model = models.Sequential()
my_model.add(layers.Dense(units=3, activation='relu', input_shape=[4]))
my_model.add(layers.Dense(units=1))

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

import matplotlib.pyplot as plt
plt.savefig('11-p-regression.pdf')

print(tmp.iloc[-1, ])

y_ = my_model.predict(X)
print(((y_.ravel() - y)**2).mean())
