import pandas as pd
my_url = ('https://raw.githubusercontent.com/taroyabuki/' +
          'fromzero/master/data/wine.csv')
my_data = pd.read_csv(my_url)
X, y = my_data.drop(columns=['LPRICE2']), my_data['LPRICE2']

import numpy as np
from scipy.stats import zscore
from sklearn.linear_model import enet_path

As = np.e**np.arange(2, -5.5, -0.1)
B  = 0.1

_, my_path, _ = enet_path(
    zscore(X), zscore(y),
    alphas=As,
    l1_ratio=B)

pd.DataFrame(
    my_path.T,
    columns=X.columns,
    index=np.log(As)
).plot(
    xlabel='log A ( = log alpha)',
    ylabel='Coefficients')

import matplotlib.pyplot as plt
plt.savefig('08-p-enet-path.pdf')
