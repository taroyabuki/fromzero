## 4.1 記述統計

### 4.1.1 平均・分散・標準偏差

import numpy as np
import pandas as pd

x = [165, 170, 175, 180, 185]
np.mean(x) # リストの場合
#> 175.0

x = np.array( # アレイ
    [165, 170, 175, 180, 185])
x.mean() # np.mean(x)も可
#> 175.0

x = pd.Series( # シリーズ
    [165, 170, 175, 180, 185])
x.mean() # np.mean(x)も可
#> 175.0

n = len(x) # サンプルサイズ
sum(x) / n
#> 175.0

y = [173, 174, 175, 176, 177]
np.mean(y)
#> 175.0

np.var(x, ddof=1) # xの分散
#> 62.5

np.var(y, ddof=1) # yの分散
#> 2.5

sum((x - np.mean(x))**2) / (n - 1)
#> 62.5

np.std(x, ddof=1) # xの標準偏差
#> 7.905694150420948

np.std(y, ddof=1) # yの標準偏差
#> 1.5811388300841898

np.var(x, ddof=1)**0.5 # xの標準偏差
#> 7.905694150420948

s = pd.Series(x)
s.describe()
#> count      5.000000 （データ数）
#> mean     175.000000 （平均）
#> std        7.905694 （標準偏差）
#> min      165.000000 （最小値）
#> 25%      170.000000 （第1四分位数）
#> 50%      175.000000 （中央値）
#> 75%      180.000000 （第3四分位数）
#> max      185.000000 （最大値）
#> dtype: float64

# s.describe()で計算済み

#### 4.1.1.1 不偏分散とその非負の平方根

x = [165, 170, 175, 180, 185]

np.var(x, ddof=1) # 不偏分散
#> 62.5

np.var(x, ddof=0) # 標本分散
#> 50.0

np.std(x, ddof=1) # √不偏分散
#> 7.905694150420949

np.std(x, ddof=0) # √標本分散
#> 7.0710678118654755

np.std(x, ddof=1) / len(x)**0.5
#> 3.5355339059327373

### 4.1.2 データフレームの統計処理

import numpy as np
import pandas as pd

my_df = pd.DataFrame({
    'name':    ['A', 'B', 'C', 'D'],
    'english': [ 60,  90,  70,  90],
    'math':    [ 70,  80,  90, 100],
    'gender':  ['f', 'm', 'm', 'f']})

#### 4.1.2.1 列ごとの集計

my_df['english'].var(ddof=1)
# あるいは
np.var(my_df['english'], ddof=1)

#> 225.0

my_df.var()
# あるいは
my_df.apply('var')
# あるいは
my_df.iloc[:, [1, 2]].apply(
    lambda x: np.var(x, ddof=1))

#> english    225.000000
#> math       166.666667
#> dtype: float64

my_df.describe()
#>        english        math
#> count      4.0    4.000000
#> mean      77.5   85.000000
#> std       15.0   12.909944
#> min       60.0   70.000000
#> 25%       67.5   77.500000
#> 50%       80.0   85.000000
#> 75%       90.0   92.500000
#> max       90.0  100.000000

#### 4.1.2.2 分割表とグループごとの集計

from collections import Counter
Counter(my_df.gender)
#> Counter({'f': 2, 'm': 2})

# あるいは

my_df.groupby('gender').apply(len)
#> gender
#> f    2
#> m    2
#> dtype: int64

my_df2 = my_df.assign(
    excel=my_df.math >= 80)
pd.crosstab(my_df2.gender,
            my_df2.excel)
#> excel   False  True
#> gender
#> f           1      1
#> m           0      2

my_df.groupby('gender').mean()
# あるいは
my_df.groupby('gender').agg('mean')
# あるいは
my_df.groupby('gender').agg(np.mean)

#>         english  math
#> gender
#> f          75.0  85.0
#> m          80.0  85.0
