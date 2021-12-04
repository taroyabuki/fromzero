## 10.1 2値分類の性能指標

### 10.1.1 陽性と陰性

import numpy as np
from sklearn.metrics import classification_report, confusion_matrix

y       = np.array([  0,   1,   1,   0,   1,   0,    1,   0,   0,   1])
y_score = np.array([0.7, 0.8, 0.3, 0.4, 0.9, 0.6, 0.99, 0.1, 0.2, 0.5])

y_ = np.array([1 if 0.5 <= p else 0 for p in y_score])
y_
#> array([1, 1, 0, 0, 1, 1, 1, 0, 0, 1])

confusion_matrix(y_true=y, y_pred=y_)
#> array([[3, 2],
#>        [1, 4]])

print(classification_report(y_true=y, y_pred=y_))
#>               precision    recall  f1-score   support
#>
#>            0       0.75      0.60      0.67         5
#>            1       0.67      0.80      0.73         5
#>
#>     accuracy                           0.70        10
#>    macro avg       0.71      0.70      0.70        10
#> weighted avg       0.71      0.70      0.70        10
