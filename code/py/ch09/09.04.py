## 9.4 複数の木を使う方法

### 9.4.1 ランダムフォレスト

import pandas as pd
import statsmodels.api as sm
import warnings
import xgboost
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV, LeaveOneOut

my_data = sm.datasets.get_rdataset('iris', 'datasets').data
X, y = my_data.iloc[:, 0:4], my_data.Species

my_search = GridSearchCV(RandomForestClassifier(),
                         param_grid={'max_features': [2, 3, 4]},
                         cv=LeaveOneOut(),
                         n_jobs=-1).fit(X, y)
my_search.best_params_
#> {'max_features': 2}

my_search.cv_results_['mean_test_score']
#> array([0.96      , 0.96      , 0.95333333])

### 9.4.2 ブースティング

warnings.simplefilter('ignore', UserWarning) # これ以降，警告を表示しない．
my_search = GridSearchCV(
    xgboost.XGBClassifier(eval_metric='mlogloss'),
    param_grid={'n_estimators'    : [50, 100, 150],
                'max_depth'       : [1, 2, 3],
                'learning_rate'   : [0.3, 0.4],
                'gamma'           : [0],
                'colsample_bytree': [0.6, 0.8],
                'min_child_weight': [1],
                'subsample'       : [0.5, 0.75, 1]},
    cv=5, # 5分割交差検証
    n_jobs=1).fit(X, y) # n_jobs=-1ではない．
warnings.simplefilter('default', UserWarning) # これ以降，警告を表示する．

my_search.best_params_
#> {'colsample_bytree': 0.6,
#>  'gamma': 0,
#>  'learning_rate': 0.3,
#>  'max_depth': 1,
#>  'min_child_weight': 1,
#>  'n_estimators': 50,
#>  'subsample': 0.75}

my_search.best_score_
#> 0.9666666666666668

### 9.4.3 入力変数の重要度

my_model = RandomForestClassifier().fit(X, y)
tmp = pd.Series(my_model.feature_importances_, index=X.columns)
tmp.sort_values().plot(kind='barh')
