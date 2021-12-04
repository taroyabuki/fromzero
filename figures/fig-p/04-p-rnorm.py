import matplotlib.pyplot as plt
import numpy as np

r = 10000
x = np.random.normal(
    loc=50,  # 平均
    scale=5, # 標準偏差
    size=r)  # 乱数の数
plt.hist(x, bins=40)

plt.savefig('04-p-rnorm.pdf')
