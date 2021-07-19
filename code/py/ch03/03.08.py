## 3.8 その他

### 3.8.1 よく遭遇するエラーとその対処方法

### 3.8.2 変数や関数についての調査

x = 123
type(x)
#> int

#> Variable   Type      Data/Info
#> ------------------------------
#> x          int       123

import math
?math.log
# あるいは
help(math.log)

### 3.8.3 RのNA，Pythonのnan

import numpy as np
v = [1, np.nan, 3]
v
#> [1, nan, 3]

np.isnan(v[1])
#> True

v[1] == np.nan # 誤り
#> False
