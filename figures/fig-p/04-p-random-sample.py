import matplotlib.pyplot as plt
import numpy as np

x = np.random.choice(
    a=range(1, 7),  # 1から6
    size=10000,     # 乱数の数
    replace=True)   # 重複あり
plt.hist(x, bins=6) # ヒストグラム

plt.savefig('04-p-random-sample.pdf')
