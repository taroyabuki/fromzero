import pandas as pd
import seaborn as sns

data = pd.read_csv('1+3x+N(0,2x).csv')
x = data.x
y = data.y
n = len(x)

alpha = 0.99
n_boot = 10000

sns.regplot(x=x, y=y, ci=100 * alpha, n_boot=n_boot)

import matplotlib.pyplot as plt
plt.savefig('confidence_band_p.pdf')
