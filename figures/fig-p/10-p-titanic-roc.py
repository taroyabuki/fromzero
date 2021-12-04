import pandas as pd
from sklearn import tree
from sklearn.metrics import roc_curve, RocCurveDisplay, auc
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder

my_url = ('https://raw.githubusercontent.com'
          '/taroyabuki/fromzero/master/data/titanic.csv')
my_data = pd.read_csv(my_url)

X, y = my_data.iloc[:, 0:3], my_data.Survived

my_pipeline = Pipeline([
    ('ohe', OneHotEncoder(drop='first')),
    ('tree', tree.DecisionTreeClassifier(max_depth=2,
                                         min_impurity_decrease=0.01))])
my_pipeline.fit(X, y)

tmp = pd.DataFrame(
    my_pipeline.predict_proba(X),
    columns=my_pipeline.classes_)
y_score = tmp.Yes

my_fpr, my_tpr, _ = roc_curve(y_true=y,
                              y_score=y_score,
                              pos_label='Yes')
my_auc = auc(x=my_fpr, y=my_tpr)
RocCurveDisplay(fpr=my_fpr, tpr=my_tpr, roc_auc=my_auc).plot()

import matplotlib.pyplot as plt
plt.savefig('10-p-titanic-roc.pdf')
