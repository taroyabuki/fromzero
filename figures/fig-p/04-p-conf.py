import numpy as np
import pandas as pd
from statsmodels.stats.proportion import binom_test

a = 0.05 # 有意水準
tmp = np.linspace(0, 1, 100)

my_df = pd.DataFrame({
    't': tmp,                                                  # 当たる確率
    'q': a,                                                    # 水平線
    'p': [binom_test(count=2, nobs=15, prop=t) for t in tmp]}) # p値

my_df.plot(x='t', legend=None, xlabel=r'$\theta$', ylabel=r'p-value')

import matplotlib.pyplot as plt
plt.savefig('04-p-conf.pdf')
