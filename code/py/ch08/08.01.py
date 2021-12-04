## 8.1 ブドウの生育条件とワインの価格

import pandas as pd
my_url = 'http://www.liquidasset.com/winedata.html'
tmp = pd.read_table(my_url, skiprows=62, nrows=38, sep='\\s+', na_values='.')
tmp.describe()
#>              OBS         VINT    LPRICE2       WRAIN    DEGREES ...
#> count  38.000000    38.000000  27.000000   38.000000  37.000000 ...
#> mean   19.500000  1970.500000  -1.451765  605.000000  16.522973 ...
# 以下省略

my_data = tmp.iloc[:, 2:].dropna()
my_data.head()
#>    LPRICE2  WRAIN  DEGREES ...
#> 0 -0.99868    600  17.1167 ...
#> 1 -0.45440    690  16.7333 ...
#> 3 -0.80796    502  17.1500 ...
#> 5 -1.50926    420  16.1333 ...
#> 6 -1.71655    582  16.4167 ...

my_data.shape
#> (27, 5)

my_data.to_csv('wine.csv',
               index=False)

#my_data = pd.read_csv('wine.csv') # 作ったファイルを使う場合
my_url = ('https://raw.githubusercontent.com/taroyabuki'
          '/fromzero/master/data/wine.csv')
my_data = pd.read_csv(my_url)
