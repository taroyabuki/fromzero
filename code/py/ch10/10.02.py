## 10.2 トレードオフ

### 10.2.1 偽陽性率と真陽性率のトレードオフ（ROC曲線）

import numpy as np
from sklearn.metrics import (roc_curve, RocCurveDisplay,
    precision_recall_curve, PrecisionRecallDisplay, auc)

y       = np.array([  0,   1,   1,   0,   1,   0,    1,   0,   0,   1])
y_score = np.array([0.7, 0.8, 0.3, 0.4, 0.9, 0.6, 0.99, 0.1, 0.2, 0.5])
y_      = np.array([1 if 0.5 <= p else 0 for p in y_score])

[sum((y == 0) & (y_ == 1)) / sum(y == 0), # FPR
 sum((y == 1) & (y_ == 1)) / sum(y == 1)] # TPR
#> [0.4, 0.8]

my_fpr, my_tpr, _ = roc_curve(y_true=y,
                              y_score=y_score,
                              pos_label=1) # 1が陽性である．
RocCurveDisplay(fpr=my_fpr, tpr=my_tpr).plot()

auc(x=my_fpr, y=my_tpr)
#> 0.8

### 10.2.2 再現率と精度のトレードオフ（PR曲線）

[sum((y == 1) & (y_ == 1)) / sum(y  == 1), # Recall == TPR
 sum((y == 1) & (y_ == 1)) / sum(y_ == 1)] # Precision
#> [0.8, 0.6666666666666666]

my_precision, my_recall, _ = precision_recall_curve(y_true=y,
                                                    probas_pred=y_score,
                                                    pos_label=1)
PrecisionRecallDisplay(precision=my_precision, recall=my_recall).plot()

auc(x=my_recall, y=my_precision)
#> 0.8463095238095237
