import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(-6, 6, 100)
y = 1 / (1 + np.exp(-x))
plt.plot(x, y)
plt.savefig('08-p-sigmoid.pdf')
