## 4.3 乱数

import matplotlib.pyplot as plt
import numpy as np
rng = np.random.default_rng()

### 4.3.1 一様乱数（離散）

x = np.random.choice(
    a=range(1, 7), # 1から6
    size=10000,    # 乱数の数
    replace=True)  # 重複あり
# あるいは
x = np.random.randint(
# あるいは
#x = rng.integers(
    low=1,      # 最小
    high=7,     # 最大+1
    size=10000) # 乱数の数

plt.hist(x, bins=6) # ヒストグラム

### 4.3.2 一様乱数（連続）

x = np.random.random(size=1000)
# あるいは
x = rng.random(size=10000)
# あるいは
x = np.random.uniform(
    low=0,     # 最小
    high=1,    # 最大
    size=1000) # 乱数の数
plt.hist(x)

tmp = np.random.uniform(
    low=1,     # 最小
    high=7,    # 最大 + 1
    size=1000) # 乱数の数
x = [int(k) for k in tmp]
plt.hist(x, bins=6) # 結果は割愛

### 4.3.3 二項乱数

n = 100
p = 0.5
r = 10000
x = np.random.binomial(
# あるいは
#x = rng.binomial(
    n=n,    # 試行回数
    p=p,    # 確率
    size=r) # 乱数の数
plt.hist(x, bins=max(x) - min(x))

### 4.3.4 正規乱数

r = 10000
x = np.random.normal(
# あるいは
#x = rng.normal(
    loc=50,  # 平均
    scale=5, # 標準偏差
    size=r)  # 乱数の数
plt.hist(x, bins=40)

#### 4.3.4.1 補足：不偏性の具体例

import numpy as np
import pandas as pd

def f(k):
    n = 10000
    tmp = [g(np.random.normal(size=k, scale=3)) for _ in range(n)]
    return pd.Series([k,
                      np.mean(tmp),                  # 平均
                      np.std(tmp, ddof=1) / n**0.5], # 標準誤差
                     index=['k', 'mean', 'se'])

def g(x):
    return np.var(x, ddof=1)
pd.Series([10, 20, 30]).apply(f)
#>       k      mean        se
#> 0  10.0  9.025140  0.042690
#> 1  20.0  9.022280  0.029525
#> 2  30.0  8.983166  0.023584

def g(x):
    return np.std(x, ddof=1)
pd.Series([10, 20, 30]).apply(f)
#>       k      mean        se
#> 0  10.0  2.923114  0.006983
#> 1  20.0  2.961450  0.004811
#> 2  30.0  2.968328  0.003977

from math import gamma

def g(x):
    n = len(x)
    return (np.std(x, ddof=1) *
            (np.sqrt((n - 1) / 2) *
             gamma((n - 1) / 2) /
             gamma(n / 2)))
pd.Series([10, 20, 30]).apply(f)
#>       k      mean        se
#> 0  10.0  3.005788  0.007121
#> 1  20.0  3.001857  0.004894
#> 2  30.0  2.995965  0.003925
