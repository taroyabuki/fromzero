## 3.5 1次元データの（非）類似度

### 3.5.1 ユークリッド距離

import numpy as np
from scipy.spatial import distance
from scipy.stats import pearsonr

A = np.array([3,   4,  5])
B = np.array([3,   4, 29])
C = np.array([9, -18,  8])

distance.euclidean(A, B)
#> 24.0

distance.euclidean(A, C)
#> 23.0

### 3.5.2 マンハッタン距離

distance.cityblock(A, B)
#> 24

distance.cityblock(A, C)
#> 31

### 3.5.3 コサイン類似度

1 - distance.cosine(A, B)
#> 0.8169678632647616

1 - distance.cosine(A, C)
#> -0.032651157422416865

### 3.5.4 相関係数

1 - distance.correlation(A, B)
# あるいは
pearsonr(A, B)[0]
#> 0.8824975032927698

1 - distance.correlation(A, C)
# あるいは
pearsonr(A, C)[0]
#> -0.032662766723200676

#### 3.5.4.1 データフレームを使う方法

# 小数点以下は3桁表示
np.set_printoptions(precision=3)
import pandas as pd

my_df = pd.DataFrame({
    'x': [3,  3,   9],
    'y': [4,  4, -18],
    'z': [5, 29,   8]},
    index=['A', 'B', 'C'])

# ユークリッド距離
distance.cdist(my_df, my_df,
               metric='euclidean')
#> array([[ 0., 24., 23.],
#>        [24.,  0., 31.],
#>        [23., 31.,  0.]])

# マンハッタン距離
distance.cdist(my_df, my_df,
               metric='cityblock')
#> array([[ 0., 24., 31.],
#>        [24.,  0., 49.],
#>        [31., 49.,  0.]])

# コサイン類似度
1 - distance.cdist(my_df, my_df,
    metric='cosine')
#> array([[ 1.   ,  0.817, -0.033],
#>        [ 0.817,  1.   ,  0.293],
#>        [-0.033,  0.293,  1.   ]])

# 相関係数
1 - distance.cdist(my_df, my_df,
    metric='correlation')
#> array([[ 1.   ,  0.882, -0.033],
#>        [ 0.882,  1.   ,  0.441],
#>        [-0.033,  0.441,  1.   ]])
