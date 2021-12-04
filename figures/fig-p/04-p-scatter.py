import statsmodels.api as sm
iris = sm.datasets.get_rdataset('iris', 'datasets').data

iris.plot('Sepal.Length',
          'Sepal.Width',
          kind='scatter')

import matplotlib.pyplot as plt
plt.savefig('04-p-scatter.pdf')
