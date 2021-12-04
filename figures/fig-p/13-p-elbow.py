import pandas as pd
import statsmodels.api as sm
from sklearn.cluster import KMeans

iris = sm.datasets.get_rdataset('iris', 'datasets').data
my_data = iris.iloc[:, 0:4]

k = range(1, 11)
my_df = pd.DataFrame({
    'k': k,
    'inertia': [KMeans(k).fit(my_data).inertia_ for k in range(1, 11)]})
my_df.plot(x='k', style='o-', legend=False)

import matplotlib.pyplot as plt
plt.savefig('13-p-elbow.pdf')
