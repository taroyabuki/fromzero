import tensorflow as tf
(x_train, y_train), (x_test, y_test) = tf.keras.datasets.mnist.load_data()

import matplotlib.pyplot as plt
plt.matshow(x_train[4, :, :])
plt.savefig('11-p-mnist-id5.pdf')
