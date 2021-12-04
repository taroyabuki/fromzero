import numpy as np
import pandas as pd
import sklearn
import statsmodels.api as sm
from keras import callbacks, layers, models
from sklearn.preprocessing import StandardScaler, LabelEncoder

tmp = sm.datasets.get_rdataset('iris', 'datasets').data
my_data = sklearn.utils.shuffle(tmp)

my_scaler = StandardScaler()
X = my_scaler.fit_transform(
    my_data.drop(columns=['Species']))
my_enc = LabelEncoder()
y = my_enc.fit_transform(
    my_data['Species'])

my_model = models.Sequential()
my_model.add(layers.Dense(units=3, activation='relu', input_shape=[4]))
my_model.add(layers.Dense(units=3, activation='softmax'))

my_model.compile(loss='sparse_categorical_crossentropy',
                 optimizer='rmsprop',
                 metrics=['accuracy'])

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
plt.savefig('11-p-classification.pdf')

print(tmp.iloc[-1, ])

tmp = my_model.predict(X)
y_ = np.argmax(tmp, axis=-1)
print((y_ == y).mean())
