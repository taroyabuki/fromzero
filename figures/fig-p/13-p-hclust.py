import pandas as pd
my_data = pd.DataFrame(
    {'x': [0, -16, 10, 10],
     'y': [0, 0, 10, -15]},
    index=['A', 'B', 'C', 'D'])

from scipy.cluster import hierarchy
my_result = hierarchy.linkage(my_data, metric='euclidean', method='complete')
hierarchy.dendrogram(my_result, labels=my_data.index)

import matplotlib.pyplot as plt
plt.savefig('13-p-hclust.pdf')
