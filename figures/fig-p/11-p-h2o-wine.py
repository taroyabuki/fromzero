import h2o
import pandas as pd
from h2o.automl import H2OAutoML

h2o.init()
h2o.no_progress()

my_url = ('https://raw.githubusercontent.com'
          '/taroyabuki/fromzero/master/data/wine.csv')
my_data = pd.read_csv(my_url)
my_frame = h2o.H2OFrame(my_data)

my_model = H2OAutoML(
    max_runtime_secs=60)
my_model.train(
    y='LPRICE2',
    training_frame=my_frame)

print(my_model.leaderboard['rmse'].min())

tmp = h2o.as_list(
    my_model.predict(my_frame))

pd.DataFrame({
    'y': my_data['LPRICE2'],
    'y_': tmp['predict']}
).plot('y', 'y_', kind='scatter')

import matplotlib.pyplot as plt
plt.savefig('11-p-h2o-wine.pdf')
