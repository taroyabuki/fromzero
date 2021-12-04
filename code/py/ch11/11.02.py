## 11.2 Kerasによる分類

import numpy as np
import pandas as pd
import statsmodels.api as sm
from keras import callbacks, layers, losses, models
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.utils import shuffle

tmp = sm.datasets.get_rdataset('iris', 'datasets').data
my_data = shuffle(tmp)

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

tmp.iloc[-1, ]
#> loss            0.067497
#> accuracy        0.973214
#> val_loss        0.143529
#> val_accuracy    0.921053

tmp = my_model.predict(X)
y_ = np.argmax(tmp, axis=-1)
(y_ == y).mean()
#> 0.96

### 11.2.1 交差エントロピー

-np.log([0.8, 0.7, 0.3, 0.8]).mean()
#> 0.5017337127232719

-np.log([0.7, 0.6, 0.2, 0.7]).mean()
#> 0.708403356019389

y = [2, 1, 0, 1]
y_1 = [[0.1, 0.1, 0.8],
       [0.1, 0.7, 0.2],
       [0.3, 0.4, 0.3],
       [0.1, 0.8, 0.1]]
y_2 = [[0.1, 0.2, 0.7],
       [0.2, 0.6, 0.2],
       [0.2, 0.5, 0.3],
       [0.2, 0.7, 0.1]]

[losses.sparse_categorical_crossentropy(y_true=y, y_pred=y_1).numpy().mean(),
 losses.sparse_categorical_crossentropy(y_true=y, y_pred=y_2).numpy().mean()]
#> [0.5017337, 0.70840335]
