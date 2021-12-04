import statsmodels.api as sm
iris = sm.datasets.get_rdataset('iris', 'datasets').data

iris.hist('Sepal.Length')

import matplotlib.pyplot as plt
plt.savefig('04-p-hist1.pdf')
