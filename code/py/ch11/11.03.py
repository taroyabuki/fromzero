## 11.3 MNIST：手書き数字の分類

### 11.3.1 データの形式

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import tensorflow as tf
from random import sample
from keras import callbacks, layers, models
from sklearn.metrics import confusion_matrix

(x_train, y_train), (x_test, y_test) = tf.keras.datasets.mnist.load_data()

x_train.shape
#> (60000, 28, 28)

np.set_printoptions(linewidth=170)
x_train[4, :, :]

plt.matshow(x_train[4, :, :])

y_train
#> array([5, 0, 4, ..., 5, 6, 8],
#>       dtype=uint8)

x_train.min(), x_train.max()
#> (0, 255)

x_train = x_train / 255
x_test  = x_test  / 255

my_index = sample(range(60000), 6000)
x_train = x_train[my_index, :, :]
y_train = y_train[my_index]

### 11.3.2 多層パーセプトロン

my_model = models.Sequential()
my_model.add(layers.Flatten(input_shape=[28, 28]))
my_model.add(layers.Dense(units=256, activation="relu"))
my_model.add(layers.Dense(units=10, activation="softmax"))

my_model.summary()
#> Model: "sequential"
#> _________________________________________________________________
#> Layer (type)                 Output Shape              Param #
#> =================================================================
#> flatten (Flatten)            (None, 784)               0
#> _________________________________________________________________
#> dense (Dense)                (None, 256)               200960
#> _________________________________________________________________
#> dense_1 (Dense)              (None, 10)                2570
#> =================================================================
#> Total params: 203,530
#> Trainable params: 203,530
#> Non-trainable params: 0
#> _________________________________________________________________

my_model.compile(loss='sparse_categorical_crossentropy',
                 optimizer='rmsprop',
                 metrics=['accuracy'])

my_cb = callbacks.EarlyStopping(patience=5, restore_best_weights=True)

my_history = my_model.fit(
    x=x_train,
    y=y_train,
    validation_split=0.2,
    batch_size=128,
    epochs=20,
    callbacks=[my_cb],
    verbose=0)

tmp = pd.DataFrame(my_history.history)
tmp.plot(xlabel='epoch', style='o-')

tmp = my_model.predict(x_test)
y_ = np.argmax(tmp, axis=-1)
confusion_matrix(y_true=y_test,
                 y_pred=y_)

#> [[ 962    0    2    1    1    2    7    1    2    2]
#>  [   0 1123    4    0    0    1    3    0    4    0]
#>  [  11    4  954   11    6    2    7    9   26    2]
#>  [   3    0   20  930    2   12    2   11   21    9]
#>  [   1    1    7    0  927    1   11    1    5   28]
#>  [  10    1    3   16    4  812   11    7   24    4]
#>  [   9    3    4    0    9   10  919    0    4    0]
#>  [   3    6   17    4   11    0    0  965    2   20]
#>  [   8    4    6   12    6    9    9    7  901   12]
#>  [   9    8    0    8   31    4    1   14    7  927]]

(y_ == y_test).mean()
#> 0.942

my_model.evaluate(x=x_test, y=y_test)
#> [0.20125965774059296,
#>  0.9419999718666077]

### 11.3.3 畳み込みニューラルネットワーク（CNN）

x_train2d = x_train.reshape(-1, 28, 28, 1)
x_test2d = x_test.reshape(-1, 28, 28, 1)

#### 11.3.3.1 単純なCNN

my_model = models.Sequential()
my_model.add(layers.Conv2D(filters=32, kernel_size=3, # 畳み込み層
                           activation='relu',
                           input_shape=[28, 28, 1]))
my_model.add(layers.MaxPooling2D(pool_size=2))        # プーリング層
my_model.add(layers.Flatten())
my_model.add(layers.Dense(128, activation='relu'))
my_model.add(layers.Dense(10, activation='softmax'))

my_model.summary()
#> Model: "sequential"
#> _________________________________________________________________
#> Layer (type)                 Output Shape              Param #
#> =================================================================
#> conv2d (Conv2D)              (None, 26, 26, 32)        320
#> _________________________________________________________________
#> max_pooling2d (MaxPooling2D) (None, 13, 13, 32)        0
#> _________________________________________________________________
#> flatten (Flatten)            (None, 5408)              0
#> _________________________________________________________________
#> dense (Dense)                (None, 128)               692352
#> _________________________________________________________________
#> dense_1 (Dense)              (None, 10)                1290
#> =================================================================
#> Total params: 693,962
#> Trainable params: 693,962
#> Non-trainable params: 0
#> _________________________________________________________________

my_model.compile(loss='sparse_categorical_crossentropy',
                 optimizer='rmsprop',
                 metrics=['accuracy'])

from keras.callbacks import EarlyStopping
my_cb = EarlyStopping(patience=5,
                      restore_best_weights=True)

my_history = my_model.fit(
    x=x_train2d,
    y=y_train,
    validation_split=0.2,
    batch_size=128,
    epochs=20,
    callbacks=my_cb,
    verbose=0)

tmp = pd.DataFrame(my_history.history)
tmp.plot(xlabel='epoch', style='o-')

my_model.evaluate(x=x_test2d, y=y_test)
#> [0.1359061449766159,
#>  0.9581000208854675]

#### 11.3.3.2 LeNet

my_model = models.Sequential()
my_model.add(layers.Conv2D(filters=20, kernel_size=5, activation='relu',
                           input_shape=(28, 28, 1)))
my_model.add(layers.MaxPooling2D(pool_size=2, strides=2))
my_model.add(layers.Conv2D(filters=20, kernel_size=5, activation='relu'))
my_model.add(layers.MaxPooling2D(pool_size=2, strides=2))
my_model.add(layers.Dropout(rate=0.25))
my_model.add(layers.Flatten())
my_model.add(layers.Dense(500, activation='relu'))
my_model.add(layers.Dropout(rate=0.5))
my_model.add(layers.Dense(10, activation='softmax'))

my_model.compile(loss='sparse_categorical_crossentropy',
                 optimizer='rmsprop',
                 metrics=['accuracy'])

my_cb = callbacks.EarlyStopping(patience=5,
                                restore_best_weights=True)

my_history = my_model.fit(
    x=x_train2d,
    y=y_train,
    validation_split=0.2,
    batch_size=128,
    epochs=20,
    callbacks=my_cb,
    verbose=0)

tmp = pd.DataFrame(my_history.history)
tmp.plot(xlabel='epoch', style='o-')

my_model.evaluate(x=x_test2d, y=y_test)
#> [0.06491111218929291,
#>  0.9797000288963318]

#### 11.3.3.3 補足：LeNetが自信満々で間違う例

y_prob = my_model.predict(x_test2d)                    # カテゴリに属する確率

tmp = pd.DataFrame({
    'y_prob': np.max(y_prob, axis=1),                  # 確率の最大値
    'y_': np.argmax(y_prob, axis=1),                   # 予測カテゴリ
    'y': y_test,                                       # 正解
    'id': range(len(y_test))})                         # 番号

tmp = tmp[tmp.y_ != tmp.y]                             # 予測がはずれたものを残す
my_result = tmp.sort_values('y_prob', ascending=False) # 確率の大きい順に並び替える

my_result.head()
#>         y_prob  y_  y    id
#> 2654  0.999997   1  6  2654
#> 1232  0.999988   4  9  1232
#> 3520  0.999926   4  6  3520
#> 9729  0.999881   6  5  9729
#> 2896  0.999765   0  8  2896

for i in range(5):
    plt.subplot(1, 5, i + 1)
    ans = my_result['y'].iloc[i]
    id = my_result['id'].iloc[i]
    plt.title(f'{ans} ({id})')
    plt.imshow(x_test[id])
    plt.axis('off')
