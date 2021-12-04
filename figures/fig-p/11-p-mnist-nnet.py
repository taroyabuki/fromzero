import numpy as np
import pandas as pd
import tensorflow as tf
from random import sample
from keras import callbacks, layers, models
from sklearn.metrics import confusion_matrix

(x_train, y_train), (x_test, y_test) = tf.keras.datasets.mnist.load_data()

my_index = sample(range(60000), 6000)
x_train = x_train[my_index, :, :]
y_train = y_train[my_index]

x_train = x_train / 255
x_test  = x_test  / 255

my_model = models.Sequential()
my_model.add(layers.Flatten(input_shape=[28, 28]))
my_model.add(layers.Dense(units=256, activation="relu"))
my_model.add(layers.Dense(units=10, activation="softmax"))

my_model.compile(loss='sparse_categorical_crossentropy',
                 optimizer='rmsprop',
                 metrics=['accuracy'])

my_cb = callbacks.EarlyStopping(patience=5,
                                restore_best_weights=True)

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

import matplotlib.pyplot as plt
plt.savefig('11-p-mnist-nnet.pdf')

tmp = my_model.predict(x_test)
y_ = np.argmax(tmp, axis=-1)
print(confusion_matrix(y_true=y_test, y_pred=y_))

print((y_test == y_).mean())

print(my_model.evaluate(x=x_test, y=y_test))
