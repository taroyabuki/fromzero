## 13.2 クラスタ分析

### 13.2.1 階層的クラスタ分析

import pandas as pd
from scipy.cluster import hierarchy

my_data = pd.DataFrame(
    {'x': [  0, -16,  10,  10],
     'y': [  0,   0,  10, -15]},
    index=['A', 'B', 'C', 'D'])

my_result = hierarchy.linkage(
    my_data,
    metric='euclidean', # 省略可
    method='complete')

hierarchy.dendrogram(my_result,
    labels=my_data.index)

hierarchy.cut_tree(my_result, 3)
#> array([[0], [1], [0], [2]])

### 13.2.2 階層的クラスタ分析とヒートマップ

import pandas as pd
import seaborn as sns

my_data = pd.DataFrame(
    {'language': [  0,  20,  20,  25,  22,  17],
     'english':  [  0,  20,  40,  20,  24,  18],
     'math':     [100,  20,   5,  30,  17,  25],
     'science':  [  0,  20,   5,  25,  16,  23],
     'society':  [  0,  20,  30,   0,  21,  17]},
    index=       ['A', 'B', 'C', 'D', 'E', 'F'])

sns.clustermap(my_data, z_score=1) # 列ごとの標準化

### 13.2.3 非階層的クラスタ分析

import pandas as pd
from sklearn.cluster import KMeans

my_data = pd.DataFrame(
    {'x': [  0, -16,  10,  10],
     'y': [  0,   0,  10, -15]},
    index=['A', 'B', 'C', 'D'])

my_result = KMeans(
    n_clusters=3).fit(my_data)

my_result.labels_
#> array([1, 0, 1, 2], dtype=int32)

### 13.2.4 クラスタ数の決定

import pandas as pd
import statsmodels.api as sm
from sklearn.cluster import KMeans

iris = sm.datasets.get_rdataset('iris', 'datasets').data
my_data = iris.iloc[:, 0:4]

k = range(1, 11)
my_df = pd.DataFrame({
    'k': k,
    'inertia': [KMeans(k).fit(my_data).inertia_ for k in range(1, 11)]})
my_df.plot(x='k', style='o-', legend=False)

### 13.2.5 主成分分析とクラスタ分析

import seaborn as sns
import statsmodels.api as sm
from pca import pca
from scipy.cluster import hierarchy
from scipy.stats import zscore
from sklearn.cluster import KMeans

iris = sm.datasets.get_rdataset('iris', 'datasets').data
my_data = zscore(iris.iloc[:, 0:4])

my_model = pca() # 主成分分析
my_result = my_model.fit_transform(my_data)['PC']
my_result['Species'] = list(iris.Species)

# 非階層的クラスタ分析の場合
my_result['cluster'] = KMeans(n_clusters=3).fit(my_data).labels_

# 階層的クラスタ分析の場合
#my_result['cluster'] = hierarchy.cut_tree(
#    hierarchy.linkage(my_data, method='complete'), 3)[:,0]

sns.scatterplot(x='PC1', y='PC2', data=my_result, legend=False,
                hue='cluster',   # 色でクラスタを表現する．
                style='Species', # 形で品種を表現する．
                palette='bright')
