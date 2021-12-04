import numpy as np
import statsmodels.api as sm
iris = sm.datasets.get_rdataset('iris', 'datasets').data

x = iris['Sepal.Length']
tmp = np.linspace(min(x), max(x), 10)
iris.hist('Sepal.Length',
          bins=tmp.round(2))

import matplotlib.pyplot as plt
plt.savefig('04-p-hist3.pdf')
