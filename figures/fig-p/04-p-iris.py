import statsmodels.api as sm
iris = sm.datasets.get_rdataset('iris', 'datasets').data

my_df = iris.describe().transpose()[['mean', 'std']]
my_df['se'] = my_df['std'] / len(iris)**0.5

my_df.plot(y='mean', kind='bar', yerr='se', capsize=10)

import matplotlib.pyplot as plt
plt.tight_layout()
plt.savefig('04-p-iris.pdf')
