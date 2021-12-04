## 3.3 コレクション

### 3.3.1 1次元データ

x = ['foo', 'bar', 'baz']

len(x)
#> 3

x[1]
#> 'bar'

x[1] = 'BAR'
x # 結果の確認
#> ['foo', 'BAR', 'baz']

x[1] = 'bar' # 元に戻す．

x[-2]
#> 'bar'

x + ['qux']
#> ['foo', 'bar', 'baz', 'qux']

x = x + ['qux']
# あるいは
#x.append('qux')

x # 結果の確認
#> ['foo', 'bar', 'baz', 'qux']

#### 3.3.1.1 等間隔の数値からなる1次元データ

list(range(5))
#> [0, 1, 2, 3, 4]

list(range(0, 11, 2))
#> [0, 2, 4, 6, 8, 10]

import numpy as np
np.arange(0, 1.1, 0.5)
#> array([0. , 0.5, 1. ])

np.linspace(0, 100, 5)
#> array([ 0., 25., 50., 75., 100.])

[10] * 5
#> [10, 10, 10, 10, 10]

#### 3.3.1.2 ファクタ（Rのみ）

### 3.3.2 数値計算やデータ解析用の1次元データ

import numpy as np
x = np.array([2, 3, 5, 7])

x + 10 # 加算
#> array([12, 13, 15, 17])

x * 10 # 乗算
#> array([20, 30, 50, 70])

x = [2, 3]
np.sin(x)
#> array([0.90929743, 0.14112001])

x = np.array([2,  3,   5,    7])
y = np.array([1, 10, 100, 1000])
x + y
#> array([   3,   13,  105, 1007])

x * y
#> array([   2,   30,  500, 7000])

np.dot(x, y)
# あるいは
x @ y

#> 7532

x = np.array([True, False])
y = np.array([True, True])
x & y
#> array([ True, False])

#### 3.3.2.1 1次元データ同士の比較

u = np.array([1, 2, 3])
v = np.array([1, 2, 3])
w = np.array([1, 2, 4])

all(u == v) # 全体の比較
#> True

all(u == w) # 全体の比較
#> False

u == v      # 要素ごとの比較
#> array([ True,  True,  True])

u == w      # 要素ごとの比較
#> array([ True,  True, False])

(u == w).sum()  # 同じ要素の数
#> 2

(u == w).mean() # 同じ要素の割合
#> [1] 0.6666667

### 3.3.3 複数種類のデータをひとまとめにする

x = [1, "two"]

x[1]
#> 'two'

### 3.3.4 文字列と値のペアのコレクション

x = {'apple' : 'りんご',
     'orange': 'みかん'}

x['grape'] = 'ぶどう'

x['apple']
# あるいは
tmp = 'apple'
x[tmp]

#> 'りんご'

### 3.3.5 補足：コピーと参照

x = ['foo', 'bar', 'baz']
y = x
y[1] = 'BAR' # yを更新する．
y
#> ['foo', 'BAR', 'baz']

x            # xも変わる．
#> ['foo', 'BAR', 'baz']

x = ['foo', 'bar', 'baz']
y = x.copy()             # 「y = x」とせずに，コピーする．
x == y, x is y
#> (True, False)         # xとyは，等価（内容は同じ）だが同一ではない．

y[1] = 'BAR'             # yを更新しても，
x
#> ['foo', 'bar', 'baz'] # xは変化しない．
