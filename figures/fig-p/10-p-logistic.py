import numpy as np
x = np.arange(-6, 6, 0.1)
y = 1 / (1 + np.exp(-x))
import matplotlib.pyplot as plt
plt.plot(x, y)
plt.savefig('10-p-logistic.pdf')
