## 4.4 統計的推測

### 4.4.1 検定

from statsmodels.stats.proportion import binom_test, proportion_confint

binom_test(count=2,                 # 当たった回数
           nobs=15,                 # くじを引いた回数
           prop=4 / 10,             # 当たる確率（仮説）
           alternative='two-sided') # 両側検定（デフォルト）
                                    # 左片側検定なら'smaller'
                                    # 右片側検定なら'larger'
#> 0.03646166155263999

#### 4.4.1.1 補足：p値とは何か

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
ax = my_data.plot(x='x', style='o', ylabel='probability',
                  legend=False)         # 凡例を表示しない．
ax.hlines(y=my_pr2, xmin=0, xmax=15)    # 水平線
ax.vlines(x=x,      ymin=0, ymax=my_pr) # 垂直線

### 4.4.2 推定

a = 0.05
proportion_confint(
    count=2, # 当たった回数
    nobs=15, # くじを引いた回数
    alpha=a, # 有意水準（省略可）
    method='binom_test')
#> (0.024225732468536626,
#>  0.3967139842509865)

a = 0.05 # 有意水準
tmp = np.linspace(0, 1, 100)

my_df = pd.DataFrame({
    't': tmp,                                                  # 当たる確率
    'q': a,                                                    # 水平線
    'p': [binom_test(count=2, nobs=15, prop=t) for t in tmp]}) # p値

my_df.plot(x='t', legend=None, xlabel=r'$\theta$', ylabel=r'p-value')

### 4.4.3 平均の差の検定と推定（t検定）

from statsmodels.stats.weightstats import CompareMeans, DescrStatsW

X = [32.1, 26.2, 27.5, 31.8, 32.1, 31.2, 30.1, 32.4, 32.3, 29.9,
     29.6, 26.6, 31.2, 30.9, 29.3]
Y = [35.4, 34.6, 31.1, 32.4, 33.3, 34.7, 35.3, 34.3, 32.1, 28.3,
     33.3, 30.5, 32.6, 33.3, 32.2]

a = 0.05          # 有意水準（デフォルト） = 1 - 信頼係数
alt = 'two-sided' # 両側検定（デフォルト）
                  # 左片側検定なら'smaller'
                  # 右片側検定なら'larger'

d = DescrStatsW(np.array(X) - np.array(Y)) # 対標本の場合
d.ttest_mean(alternative=alt)[1]           # p値
#> 0.0006415571512322235

d.tconfint_mean(alpha=a, alternative=alt) # 信頼区間
#> (-3.9955246743198867, -1.3644753256801117)

c = CompareMeans(DescrStatsW(X), DescrStatsW(Y)) # 対標本でない場合

ve = 'pooled' # 等分散を仮定する（デフォルト）．仮定しないなら'unequal'．
c.ttest_ind(alternative=alt, usevar=ve)[1] # p値
#> 0.000978530937238609

c.tconfint_diff(alpha=a, alternative=alt, usevar=ve) # 信頼区間
#> (-4.170905570517185, -1.1890944294828283)

### 4.4.4 独立性の検定（カイ2乗検定）

import pandas as pd
my_url = ('https://raw.githubusercontent.com/taroyabuki'
          '/fromzero/master/data/smoker.csv')
my_data = pd.read_csv(my_url)

my_data.head()
#>   alive smoker
#> 0   Yes     No
#> 1   Yes     No
#> 2   Yes     No
#> 3   Yes     No
#> 4   Yes     No

my_table = pd.crosstab(
    my_data['alive'],
    my_data['smoker'])
my_table
#> smoker   No  Yes
#> alive
#> No      117   54
#> Yes     950  348

from scipy.stats import chi2_contingency
chi2_contingency(my_table, correction=False)[1]
#> 0.18860725715300422

### 4.4.5 ブートストラップ

#### 4.4.5.1 15回引いて2回当たったくじ

X = [0] * 13 + [1] * 2 # 手順1
X
#> [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1]

tmp = np.random.choice(X, 15, replace=True) # 手順2
tmp
#> array([0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0])

sum(tmp) # 手順3
#> 2

n = 10**5
result = [sum(np.random.choice(X, len(X), replace=True)) for _ in range(n)] # 手順4

import matplotlib.pyplot as plt
plt.hist(result, bins=range(0, 16))

np.quantile(result, [0.025, 0.975])
#> array([0., 5.])

#### 4.4.5.2 平均の差の信頼区間

import numpy as np
X = [32.1, 26.2, 27.5, 31.8, 32.1, 31.2, 30.1, 32.4, 32.3, 29.9,
     29.6, 26.6, 31.2, 30.9, 29.3]
Y = [35.4, 34.6, 31.1, 32.4, 33.3, 34.7, 35.3, 34.3, 32.1, 28.3,
     33.3, 30.5, 32.6, 33.3, 32.2]
Z = np.array(X) - np.array(Y) # 対標本として扱う．

n = 10**5
result = [np.random.choice(Z, len(Z), replace=True).mean() for _ in range(n)]

np.quantile(result, [0.025, 0.975])
#> array([-3.88666667, -1.55333333])

plt.hist(result, bins='sturges')

result = [np.random.choice(X, len(X), replace=True).mean() -
          np.random.choice(Y, len(Y), replace=True).mean()
          for _ in range(n)]
np.quantile(result, [0.025, 0.975])
#> array([-4.06, -1.3 ])
