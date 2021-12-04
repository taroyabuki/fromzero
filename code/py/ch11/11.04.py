## 11.4 AutoML

### 11.4.1 H2Oの起動と停止

import h2o
import pandas as pd
import tensorflow as tf
from h2o.automl import H2OAutoML
from random import sample

h2o.init()
h2o.no_progress()
# h2o.cluster().shutdown() # 停止

### 11.4.2 H2Oのデータフレーム

my_url = ('https://raw.githubusercontent.com/taroyabuki'
          '/fromzero/master/data/wine.csv')
my_data = pd.read_csv(my_url)
my_frame = h2o.H2OFrame(my_data) # 通常のデータフレームをH2OFrameに変換する．
# あるいは
my_frame = h2o.import_file(my_url, header=1) # データを読み込む．

my_frame.head(5)
#>   LPRICE2    WRAIN    DEGREES  ...
#> ---------  -------  ---------  ...
#>  -0.99868      600    17.1167  ...
#>  -0.4544       690    16.7333  ...
#>  -0.80796      502    17.15    ...
#>  -1.50926      420    16.1333  ...
#>  -1.71655      582    16.4167  ...

# 通常のデータフレームに戻す．
h2o.as_list(my_frame).head()
# 結果は割愛（見た目は同じ）

### 11.4.3 AutoMLによる回帰

my_model = H2OAutoML(
    max_runtime_secs=60)
my_model.train(
    y='LPRICE2',
    training_frame=my_frame)

my_model.leaderboard['rmse'].min()
#> 0.2704643402377778

tmp = h2o.as_list(
    my_model.predict(my_frame))

pd.DataFrame({
    'y': my_data['LPRICE2'],
    'y_': tmp['predict']}
).plot('y', 'y_', kind='scatter')

### 11.4.4 AutoMLによる分類

(x_train, y_train), (x_test, y_test) = tf.keras.datasets.mnist.load_data()
my_index = sample(range(60000), 6000)
x_train = x_train[my_index, :, :]
y_train = y_train[my_index]

tmp = pd.DataFrame(
    x_train.reshape(-1, 28 * 28))
y = 'y'
tmp[y] = y_train
my_train = h2o.H2OFrame(tmp)
my_train[y] = my_train[y].asfactor()

tmp = pd.DataFrame(
    x_test.reshape(-1, 28 * 28))
my_test = h2o.H2OFrame(tmp)

my_model = H2OAutoML(
    max_runtime_secs=120)
my_model.train(
    y=y,
    training_frame=my_train)

my_model.leaderboard[
    'mean_per_class_error'].min()
#> 0.06803754348177862

tmp = h2o.as_list(
    my_model.predict(my_test))
y_ = tmp.predict

(y_ == y_test).mean()
#> 0.938
