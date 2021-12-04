import pandas as pd
my_data = pd.DataFrame(
    {'language': (  0, 20, 20, 25, 22, 17),
     'english':  (  0, 20, 40, 20, 24, 18),
     'math':     (100, 20,  5, 30, 17, 25),
     'science':  (  0, 20,  5, 25, 16, 23),
     'society':  (  0, 20, 30,  0, 21, 17)},
    index=['A', 'B', 'C', 'D', 'E', 'F'])

from pca import pca
my_model = pca(n_components=5)
my_result = my_model.fit_transform(my_data)

my_model.biplot(legend=False) # バイプロット

import matplotlib.pyplot as plt
plt.savefig('13-p-biplot.pdf')
