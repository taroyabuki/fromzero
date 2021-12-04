import pandas as pd

my_df = pd.DataFrame({'x': [10, 20, 30]})
my_df.hist('x', bins=2) # 階級数は2

import matplotlib.pyplot as plt
plt.savefig('04-p-hist2.pdf')
