## 10.4 ロジスティック回帰

import matplotlib.pyplot as plt
import numpy as np

x = np.arange(-6, 6, 0.1)
y = 1 / (1 + np.exp(-x))
plt.plot(x, y)

import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import cross_val_score, LeaveOneOut
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder

my_url = ('https://raw.githubusercontent.com/taroyabuki'
          '/fromzero/master/data/titanic.csv')
my_data = pd.read_csv(my_url)

X, y = my_data.iloc[:, 0:3], my_data.Survived

my_pipeline = Pipeline([('ohe', OneHotEncoder(drop='first')),
                        ('lr', LogisticRegression(penalty='none'))])
my_pipeline.fit(X, y)

my_ohe = my_pipeline.named_steps.ohe
my_lr  = my_pipeline.named_steps.lr

my_lr.intercept_[0]
#> 2.043878162056783

tmp = my_ohe.get_feature_names() \
if hasattr(my_ohe, 'get_feature_names') \
else my_ohe.get_feature_names_out()
pd.Series(my_lr.coef_[0],
          index=tmp)
#> x0_2nd     -1.018069
#> x0_3rd     -1.777746
#> x0_Crew    -0.857708
#> x1_Male    -2.420090
#> x2_Child    1.061531
#> dtype: float64

my_scores = cross_val_score(
    my_pipeline, X, y,
    cv=LeaveOneOut(),
    n_jobs=-1)
my_scores.mean()
#> 0.7782825988187188
