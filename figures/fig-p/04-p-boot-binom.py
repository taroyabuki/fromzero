import numpy as np
X = [0] * 13 + [1] * 2 # 手順1
n = 10**5
result = [sum(np.random.choice(X, len(X), replace=True)) # 手順4
          for _ in range(n)]

import matplotlib.pyplot as plt
plt.hist(result,
         bins=range(0, 16))
plt.savefig('04-p-boot-binom.pdf')
