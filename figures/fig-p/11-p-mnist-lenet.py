import pandas as pd
from random import sample
import tensorflow as tf
from keras import callbacks, layers, models

(x_train, y_train), (x_test, y_test) = tf.keras.datasets.mnist.load_data()

my_index = sample(range(60000), 6000)
x_train = x_train[my_index, :, :]
y_train = y_train[my_index]

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

tmp = pd.DataFrame(my_history.history)
tmp.plot(xlabel='epoch', style='o-')

import matplotlib.pyplot as plt
plt.savefig('11-p-mnist-lenet.pdf')

print(my_model.evaluate(x=x_test2d, y=y_test))
