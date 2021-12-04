import pandas as pd
from sklearn.preprocessing import StandardScaler

my_url = ('https://raw.githubusercontent.com/taroyabuki/' +
          'fromzero/master/data/wine.csv')
my_data = pd.read_csv(my_url)
X, y = my_data.drop(columns=['LPRICE2']), my_data['LPRICE2']

pd.DataFrame(StandardScaler().fit_transform(X),
             columns=X.columns).boxplot(showmeans=True)

import matplotlib.pyplot as plt
plt.savefig('08-p-boxplot-scaled.pdf')
