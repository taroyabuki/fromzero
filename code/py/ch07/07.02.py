## 7.2 データの確認

import statsmodels.api as sm
my_data = sm.datasets.get_rdataset('cars', 'datasets').data

my_data.shape
#> (50, 2)

my_data.head()
#>    speed  dist
#> 0      4     2
#> 1      4    10
#> 2      7     4
#> 3      7    22
#> 4      8    16

my_data.describe()
#>            speed        dist
#> count  50.000000   50.000000
#> mean   15.400000   42.980000
#> std     5.287644   25.769377
#> min     4.000000    2.000000
#> 25%    12.000000   26.000000
#> 50%    15.000000   36.000000
#> 75%    19.000000   56.000000
#> max    25.000000  120.000000

my_data.plot(x='speed', style='o')
