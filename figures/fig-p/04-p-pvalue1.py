import numpy as np
import pandas as pd
from scipy import stats

t = 4 / 10                        # 当たる確率
n = 15                            # くじを引いた回数
x = np.array(range(0, n + 1))     # 当たった回数
my_pr  = stats.binom.pmf(x, n, t) # x回当たる確率
my_pr2 = stats.binom.pmf(2, n, t) # 2回当たる確率

my_data = pd.DataFrame({'x': x, 'y1': my_pr, 'y2': my_pr})
my_data.loc[my_pr >  my_pr2, 'y1'] = np.nan # 当たる確率が，2回当たる確率超過
my_data.loc[my_pr <= my_pr2, 'y2'] = np.nan # 当たる確率が，2回当たる確率以下
ax = my_data.plot(x='x', style='o', ylabel='probability', legend=False)
ax.hlines(y=my_pr2, xmin=0, xmax=15)    # 水平線
ax.vlines(x=x,      ymin=0, ymax=my_pr) # 垂直線

import matplotlib.pyplot as plt
plt.savefig('04-p-pvalue1.pdf')
