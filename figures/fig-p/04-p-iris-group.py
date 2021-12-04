import statsmodels.api as sm
iris = sm.datasets.get_rdataset('iris', 'datasets').data

my_group = iris.groupby('Species')                    # 品種ごとに，
my_df = my_group.agg('mean')                          # 各変数の，平均と
my_se = my_group.agg(lambda x: x.std() / len(x)**0.5) # 標準誤差を求める．

my_df.plot(kind='bar', yerr=my_se, capsize=5)

import matplotlib.pyplot as plt
plt.savefig('04-p-iris-group.pdf')
