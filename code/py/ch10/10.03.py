## 10.3 タイタニック

import graphviz
import pandas as pd
from sklearn import tree
from sklearn.metrics import roc_curve, RocCurveDisplay, auc
from sklearn.model_selection import cross_val_score, LeaveOneOut
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder

my_url = ('https://raw.githubusercontent.com/taroyabuki'
          '/fromzero/master/data/titanic.csv')
my_data = pd.read_csv(my_url)

my_data.head()
#>   Class   Sex    Age Survived
#> 0   1st  Male  Child      Yes
#> 1   1st  Male  Child      Yes
#> 2   1st  Male  Child      Yes
#> 3   1st  Male  Child      Yes
#> 4   1st  Male  Child      Yes

### 10.3.1 質的入力変数の扱い方

### 10.3.2 決定木の訓練

X, y = my_data.iloc[:, 0:3], my_data.Survived

my_pipeline = Pipeline([
    ('ohe', OneHotEncoder(drop='first')),
    ('tree', tree.DecisionTreeClassifier(max_depth=2, random_state=0,
                                         min_impurity_decrease=0.01))])
my_pipeline.fit(X, y)

### 10.3.3 決定木の描画

my_enc  = my_pipeline.named_steps['ohe']  # パイプラインからエンコーダを取り出す．
my_tree = my_pipeline.named_steps['tree'] # パイプラインから木を取り出す．

my_dot = tree.export_graphviz(
    decision_tree=my_tree,
    out_file=None,
    feature_names=my_enc.get_feature_names_out() if hasattr(my_enc, 'get_feature_names_out') else my_enc.get_feature_names(),
    class_names=my_pipeline.classes_,
    filled=True)
graphviz.Source(my_dot)

### 10.3.4 決定木の評価

my_scores = cross_val_score(
    my_pipeline, X, y,
    cv=LeaveOneOut(),
    n_jobs=-1)
my_scores.mean()
#> 0.7832803271240345

tmp = pd.DataFrame(
    my_pipeline.predict_proba(X),
    columns=my_pipeline.classes_)
y_score = tmp.Yes

my_fpr, my_tpr, _ = roc_curve(y_true=y,
                              y_score=y_score,
                              pos_label='Yes')
my_auc = auc(x=my_fpr, y=my_tpr)
my_auc
#> 0.7114886868858494

RocCurveDisplay(fpr=my_fpr, tpr=my_tpr, roc_auc=my_auc).plot()

### 10.3.5 補足：質的入力変数の扱い
