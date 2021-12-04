import matplotlib.pyplot as plt
import numpy as np

x = np.random.random(1000)
plt.hist(x)

plt.savefig('04-p-runif.pdf')
