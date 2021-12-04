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

sns.scatterplot(x='PC1', y='PC2', data=my_result,
                hue='cluster', style='Species', palette='bright', legend=False)

import matplotlib.pyplot as plt
plt.savefig('13-p-pca-clusters.pdf')
