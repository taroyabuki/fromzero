## 3.4 データフレーム

### 3.4.1 データフレームの作成

import pandas as pd

#### 3.4.1.1 データを列ごとに記述する方法

my_df = pd.DataFrame({
    'name':    ['A', 'B', 'C', 'D'],
    'english': [ 60,  90,  70,  90],
    'math':    [ 70,  80,  90, 100],
    'gender':  ['f', 'm', 'm', 'f']})

#### 3.4.1.2 データを見た目のとおりに記述する方法

my_df = pd.DataFrame([
    ['A', 60,  70, 'f'],
    ['B', 90,  80, 'm'],
    ['C', 70,  90, 'm'],
    ['D', 90, 100, 'f']],
    columns=['name', 'english',
             'math', 'gender'])

my_df.head()
# 結果は割愛

#### 3.4.1.3 データフレームのサイズ

r, c = my_df.shape # 行数と列数
r, c
#> (4, 4)

r # 行数（len(my_df)も可）
#> 4

c # 列数
#> 4

#### 3.4.1.4 組合せ

from itertools import product
my_df2 = pd.DataFrame(
    product([1, 2, 3],
            [10, 100]),
    columns=['X', 'Y'])
my_df2
#>    X    Y
#> 0  1   10
#> 1  1  100
#> 2  2   10
#> 3  2  100
#> 4  3   10
#> 5  3  100

#### 3.4.1.5 列と行の名前

my_df2.columns
#> Index(['X', 'Y'], dtype='object')

my_df2.columns = ['P', 'Q']
my_df2
#>    P    Q
#> 0  1   10
#> 1  1  100
# 以下省略

list(my_df.index)
#> [0, 1, 2, 3]

my_df2.index = [
    'a', 'b', 'c', 'd', 'e', 'f']
my_df2
#>    P    Q
#> a  1   10
#> b  1  100
#> c  2   10
# 以下省略

my_df3 = pd.DataFrame({
    'english': [ 60,  90,  70,  90],
    'math':    [ 70,  80,  90, 100],
    'gender':  ['f', 'm', 'm', 'f']},
    index=     ['A', 'B', 'C', 'D'])
my_df3
#>    english  math gender
#> A       60    70      f
#> B       90    80      m
#> C       70    90      m
#> D       90   100      f

### 3.4.2 データの追加

#### 3.4.2.1 行の追加（データフレームの結合）

tmp = pd.DataFrame({
    'name'   : ['E'],
    'english': [80],
    'math'   : [80],
    'gender' : ['m']})
my_df2 = my_df.append(tmp)

#### 3.4.2.2 列の追加

my_df2 = my_df.assign(id=[1, 2, 3, 4])

my_df3 = my_df.copy()       # コピー
my_df3['id'] = [1, 2, 3, 4] # 更新
my_df3 # 結果の確認（割愛）

### 3.4.3 データの取り出し

#### 3.4.3.1 観測値の取り出し

my_df.iloc[0, 1]
#> 60

#### 3.4.3.2 1列の取り出し（結果は1次元データ）

x = my_df.iloc[:, 1]
# あるいは
x = my_df['english']
# あるいは
x = my_df.english
# あるいは
tmp = 'english'
x = my_df[tmp]

x # 結果の確認（割愛）

#### 3.4.3.3 複数列の取り出し（結果はデータフレーム）

x = my_df[['name', 'math']]
# あるいは
x = my_df.loc[:, ['name', 'math']]

x = my_df.take([0, 2], axis=1)
# あるいは
x = my_df.iloc[:, [0, 2]]

x = my_df.drop(
    columns=['english', 'gender'])
# あるいは
x = my_df.drop(
    columns=my_df.columns[[1, 3]])

#### 3.4.3.4 複数行の取り出し（結果はデータフレーム）

x = my_df.take([0, 2])
# あるいは
x = my_df.iloc[[0, 2], :]

x = my_df.drop([1, 3])

#### 3.4.3.5 検索

x = my_df[my_df['gender'] == 'm']
# あるいは
x = my_df.query('gender == "m"')

x = my_df[(my_df['english'] > 80) & (my_df['gender'] == "m")]
# あるいは
x = my_df.query('english > 80 and gender == "m"')

x = my_df[my_df['english'] == my_df['english'].max()]
# あるいは
tmp = my_df['english'].max()
x = my_df.query('english == @tmp')

my_df2 = my_df.copy() # コピー
my_df2.loc[my_df['gender'] == 'm', 'gender'] = 'M'

my_df2
#>   name  english  math gender
#> 0    A       60    70      f
#> 1    B       90    80      M
#> 2    C       70    90      M
#> 3    D       90   100      f

#### 3.4.3.6 並べ替え

x = my_df.sort_values('english')

x = my_df.sort_values('english',
    ascending=False)

### 3.4.4 補足：行列

#### 3.4.4.1 行列の生成

import numpy as np
x = [2, 3, 5, 7, 11, 13, 17, 19, 23,
     29, 31, 37]
A = np.array(x).reshape(3, 4)
A
#> array([[ 2,  3,  5,  7],
#>        [11, 13, 17, 19],
#>        [23, 29, 31, 37]])

#### 3.4.4.2 データフレームと行列

A = my_df.iloc[:, [1, 2]].values
A
#> array([[ 60,  70],
#>        [ 90,  80],
#>        [ 70,  90],
#>        [ 90, 100]])

pd.DataFrame(A)
#>     0    1
#> 0  60   70
#> 1  90   80
#> 2  70   90
#> 3  90  100

#### 3.4.4.3 行列の変形

A.T
#> array([[ 60,  90,  70,  90],
#>        [ 70,  80,  90, 100]])

#### 3.4.4.4 行列の積

A.T @ A
#> array([[24700, 26700],
#>        [26700, 29400]])

### 3.4.5 縦型と横型

my_df = pd.DataFrame({
    'day': [25, 26, 27],
    'min': [20, 21, 15],
    'max': [24, 27, 21]})

my_longer = my_df.melt(id_vars='day')
my_longer
#>    day variable  value
#> 0   25      min     20
#> 1   26      min     21
#> 2   27      min     15
#> 3   25      max     24
#> 4   26      max     27
#> 5   27      max     21

my_wider = my_longer.pivot(
    index='day',
    columns='variable',
    values='value')
my_wider
#> variable  max  min
#> day
#> 25         24   20
#> 26         27   21
#> 27         21   15

my_wider.plot(
    style='o-',
    xticks=my_wider.index, # x軸目盛り
    ylabel='temperature')  # y軸ラベル
