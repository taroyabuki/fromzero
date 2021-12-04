import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import tensorflow as tf
from random import sample
from keras import callbacks, layers, models

(x_train, y_train), (x_test, y_test) = tf.keras.datasets.mnist.load_data()

#my_index = sample(range(60000), 6000)
#x_train = x_train[my_index, :, :]
#y_train = y_train[my_index]

x_train = x_train / 255
x_test  = x_test  / 255

x_train2d = x_train.reshape(-1, 28, 28, 1)
x_test2d = x_test.reshape(-1, 28, 28, 1)

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
    callbacks=[my_cb],
    verbose=0)

y_prob = my_model.predict(x_test2d)                    # カテゴリに属する確率

tmp = pd.DataFrame({
    'y_prob': np.max(y_prob, axis=1),                  # 確率の最大値
    'y_': np.argmax(y_prob, axis=1),                   # 予測カテゴリ
    'y': y_test,                                       # 正解
    'id': range(len(y_test))})                         # 番号

tmp = tmp[tmp.y_ != tmp.y]                             # 予測がはずれたものを残す
my_result = tmp.sort_values('y_prob', ascending=False) # 確率の大きい順に並び替える
print(my_result.head())

for i in range(5):
    plt.subplot(1, 5, i + 1)
    ans = my_result['y'].iloc[i]
    id = my_result['id'].iloc[i]
    plt.title(f'{ans} ({id})')
    plt.imshow(x_test[id])
    plt.axis('off')

plt.savefig('11-p-mnist-lenet-miss.pdf')
