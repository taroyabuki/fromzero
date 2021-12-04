import numpy as np
y       = np.array([  0,   1,   1,   0,   1,   0,    1,   0,   0,   1])
y_score = np.array([0.7, 0.8, 0.3, 0.4, 0.9, 0.6, 0.99, 0.1, 0.2, 0.5])

from sklearn.metrics import roc_curve, RocCurveDisplay

my_fpr, my_tpr, _ = roc_curve(y_true=y,
                              y_score=y_score,
                              pos_label=1)
RocCurveDisplay(fpr=my_fpr, tpr=my_tpr).plot()

import matplotlib.pyplot as plt
plt.savefig('10-p-roc.pdf')
