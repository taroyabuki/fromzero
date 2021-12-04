## 5.2 データの変換

### 5.2.1 標準化

import numpy as np
from scipy.stats import zscore

x1 = [1, 2, 3]

z1 = ((x1 - np.mean(x1)) /
      np.std(x1, ddof=1))
# あるいは
z1 = zscore(x1, ddof=1)

z1
#> array([-1.,  0.,  1.])

z1.mean(), np.std(z1, ddof=1)
#> (0.0, 1.0)

z1 * np.std(x1, ddof=1) + np.mean(x1)
#> array([1., 2., 3.])

x2 = [1, 3, 5]
z2 = ((x2 - np.mean(x1)) /
      np.std(x1, ddof=1))
z2.mean(), np.std(z2, ddof=1)
#> (1.0, 2.0)

### 5.2.2 ワンホットエンコーディング

import pandas as pd
from sklearn.preprocessing import (
    OneHotEncoder)

my_df = pd.DataFrame({
    'id':    [ 1 ,  2 ,  3 ],
    'class': ['A', 'B', 'C']})

my_enc = OneHotEncoder()
tmp = my_enc.fit_transform(
    my_df[['class']]).toarray()
my_names = my_enc.get_feature_names()
pd.DataFrame(tmp, columns=my_names)
#>    x0_A  x0_B  x0_C
#> 0   1.0   0.0   0.0
#> 1   0.0   1.0   0.0
#> 2   0.0   0.0   1.0

my_df2 = pd.DataFrame({
    'id':    [ 4 ,  5,   6 ],
    'class': ['B', 'C', 'B']})
tmp = my_enc.transform(
    my_df2[['class']]).toarray()
pd.DataFrame(tmp, columns=my_names)
#>    x0_A  x0_B  x0_C
#> 0   0.0   1.0   0.0
#> 1   0.0   0.0   1.0
#> 2   0.0   1.0   0.0

#### 5.2.2.1 補足：冗長性の排除

my_enc = OneHotEncoder(drop='first')

tmp = my_enc.fit_transform(
    my_df[['class']]).toarray()
my_names = my_enc.get_feature_names()
pd.DataFrame(tmp, columns=my_names)
#>    x0_B  x0_C
#> 0   0.0   0.0
#> 1   1.0   0.0
#> 2   0.0   1.0

tmp = my_enc.transform(
    my_df2[['class']]).toarray()
pd.DataFrame(tmp, columns=my_names)
#>    x0_B  x0_C
#> 0   1.0   0.0
#> 1   0.0   1.0
#> 2   1.0   0.0
