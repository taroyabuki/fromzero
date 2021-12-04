import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(-2, 2, 100)
y = x**3 - x
plt.plot(x, y)

plt.savefig('04-p-curve.pdf')
