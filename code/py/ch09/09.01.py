## 9.1 アヤメのデータ

import statsmodels.api as sm
my_data = sm.datasets.get_rdataset('iris', 'datasets').data
my_data.head()
#>    Sepal.Length  Sepal.Width  Petal.Length  Petal.Width Species
#> 0           5.1          3.5           1.4          0.2  setosa
#> 1           4.9          3.0           1.4          0.2  setosa
#> 2           4.7          3.2           1.3          0.2  setosa
#> 3           4.6          3.1           1.5          0.2  setosa
#> 4           5.0          3.6           1.4          0.2  setosa

my_data.describe()
#>        Sepal.Length  Sepal.Width  Petal.Length  Petal.Width
#> count    150.000000   150.000000    150.000000   150.000000
#> mean       5.843333     3.057333      3.758000     1.199333
# 以下省略
