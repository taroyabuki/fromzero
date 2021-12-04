import statsmodels.api as sm
iris = sm.datasets.get_rdataset('iris', 'datasets').data

import pandas as pd
from statsmodels.graphics.mosaicplot \
    import mosaic

my_df = pd.DataFrame({
    'Species': iris.Species,
    'w_Sepal': iris['Sepal.Width'] > 3})
mosaic(my_df,
       index=['Species', 'w_Sepal'])

import matplotlib.pyplot as plt
plt.savefig('04-p-mosaic.pdf')
