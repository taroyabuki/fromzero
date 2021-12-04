import seaborn as sns
import statsmodels.api as sm

my_data = sm.datasets.get_rdataset('cars', 'datasets').data
ax = sns.regplot(x='speed', y='dist', data=my_data)
ax.vlines(x=21.5, ymin=-5, ymax=67,   linestyles='dotted')
ax.hlines(y=67,   xmin=4,  xmax=21.5, linestyles='dotted')
ax.set_xlim(4, 25)
ax.set_ylim(-5, 125)

import matplotlib.pyplot as plt
plt.savefig('07-p-regression.pdf')
