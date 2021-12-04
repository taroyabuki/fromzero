## 9.6 他の分類手法

### 9.6.1 K最近傍法

import statsmodels.api as sm
from sklearn.model_selection import cross_val_score, LeaveOneOut
from sklearn.neighbors import KNeighborsClassifier

my_data = sm.datasets.get_rdataset('iris', 'datasets').data
X, y = my_data.iloc[:, 0:4], my_data.Species

my_scores = cross_val_score(KNeighborsClassifier(), X, y, cv=LeaveOneOut())
my_scores.mean()
#> 0.9666666666666667

### 9.6.2 ニューラルネットワーク

import statsmodels.api as sm
from sklearn.model_selection import cross_val_score, LeaveOneOut
from sklearn.neural_network import MLPClassifier
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

my_data = sm.datasets.get_rdataset('iris', 'datasets').data
X, y = my_data.iloc[:, 0:4], my_data.Species

my_pipeline = Pipeline([('sc', StandardScaler()),  # 標準化
                        ('mlp', MLPClassifier())]) # ニューラルネットワーク
my_scores = cross_val_score(my_pipeline, X, y, cv=LeaveOneOut(), n_jobs=-1)
my_scores.mean()
#> 0.9533333333333334
