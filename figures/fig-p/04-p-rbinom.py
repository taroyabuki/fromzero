import matplotlib.pyplot as plt
import numpy as np

n = 100
p = 0.5
r = 10000
x = np.random.binomial(
    n=n,    # 試行回数
    p=p,    # 確率
    size=r) # 乱数の数
plt.hist(x, bins=max(x) - min(x))

plt.savefig('04-p-rbinom.pdf')
