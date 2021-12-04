import pandas as pd
import statsmodels.api as sm
from sklearn.ensemble import RandomForestClassifier

iris = sm.datasets.get_rdataset('iris', 'datasets').data
X, y = iris.iloc[:, 0:4], iris.Species

my_model = RandomForestClassifier().fit(X, y)
tmp = pd.Series(my_model.feature_importances_, index=X.columns)
tmp.sort_values().plot(kind='barh')

import matplotlib.pyplot as plt
plt.tight_layout()
plt.savefig('09-p-varimp.pdf')
