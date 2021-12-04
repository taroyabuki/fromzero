import statsmodels.api as sm
iris = sm.datasets.get_rdataset('iris', 'datasets').data

iris.boxplot()

import matplotlib.pyplot as plt
plt.savefig('04-p-boxplot.pdf')
