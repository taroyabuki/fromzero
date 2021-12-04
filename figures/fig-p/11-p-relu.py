import matplotlib.pyplot as plt
import numpy as np
from keras import activations

x = np.linspace(-3, 3, 100)
plt.plot(x, activations.relu(x))
plt.xlabel('x')
plt.ylabel('ReLU(x)')
plt.savefig('11-p-relu.pdf')
