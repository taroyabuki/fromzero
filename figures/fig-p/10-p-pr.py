import numpy as np
y       = np.array([  0,   1,   1,   0,   1,   0,    1,   0,   0,   1])
y_score = np.array([0.7, 0.8, 0.3, 0.4, 0.9, 0.6, 0.99, 0.1, 0.2, 0.5])

from sklearn.metrics import precision_recall_curve, PrecisionRecallDisplay

my_precision, my_recall, _ = precision_recall_curve(y_true=y,
                                                    probas_pred=y_score,
                                                    pos_label=1)
PrecisionRecallDisplay(precision=my_precision, recall=my_recall).plot()

import matplotlib.pyplot as plt
plt.savefig('10-p-pr.pdf')
