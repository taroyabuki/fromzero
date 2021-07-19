## 9.2 木による分類

### 9.2.1 分類木の作成と利用

import graphviz
import pandas as pd
import statsmodels.api as sm
from sklearn import tree

my_data = sm.datasets.get_rdataset('iris', 'datasets').data
X, y = my_data.iloc[:, 0:4], my_data.Species

my_model = tree.DecisionTreeClassifier(max_depth=2, random_state=0)
my_model.fit(X, y)

my_dot = tree.export_graphviz(
    decision_tree=my_model,
    out_file=None,                 # ファイルに出力しない．
    feature_names=X.columns,       # 変数名
    class_names=my_model.classes_, # カテゴリ名
    filled=True)                   # 色を塗る．
graphviz.Source(my_dot)

my_test = pd.DataFrame([[5.0, 3.5, 1.5, 0.5],
                        [6.5, 3.0, 5.0, 2.0]])
my_model.predict(my_test)
#> array(['setosa', 'virginica'], dtype=object)

pd.DataFrame(
    my_model.predict_proba(my_test),
    columns=my_model.classes_)
#>    setosa  versicolor  virginica
#> 0     1.0    0.000000   0.000000
#> 1     0.0    0.021739   0.978261
