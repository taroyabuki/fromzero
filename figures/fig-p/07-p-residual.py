import statsmodels.api as sm
from sklearn.linear_model import LinearRegression

my_data = sm.datasets.get_rdataset('cars', 'datasets').data
X, y = my_data[['speed']], my_data['dist']

my_model = LinearRegression()
my_model.fit(X, y)
y_ = my_model.predict(X)
my_data['y_'] = y_

ax = my_data.plot(x='speed', y='dist', style='o', legend=False)
my_data.plot(x='speed', y='y_', style='-', legend=False, ax=ax)
ax.vlines(x=X, ymin=y, ymax=y_, linestyles='dotted')

import matplotlib.pyplot as plt
plt.savefig('07-p-residual.pdf')
