## 5.1 データの読み込み

### 5.1.1 CSV


#### 5.1.1.1 CSVの読み込み

import pandas as pd
my_df = pd.read_csv('exam.csv')
my_df
#>   name  english  math gender
#> 0    A       60    70      f
#> 1    B       90    80      m
#> 2    C       70    90      m
#> 3    D       90   100      f

my_url = ('https://raw.githubusercontent.com/taroyabuki'
          '/fromzero/master/data/exam.csv')
my_df = pd.read_csv(my_url)

my_df2 = pd.read_csv('exam.csv',
    index_col='name')
my_df2
#>       english  math gender
#> name
#> A          60    70      f
#> B          90    80      m
#> C          70    90      m
#> D          90   100      f

#### 5.1.1.2 CSVファイルへの書き出し

my_df.to_csv('exam2.csv', index=False)

my_df2.to_csv('exam3.csv')

### 5.1.2 文字コード

my_df = pd.read_csv('exam.csv',
    encoding='UTF-8')

my_df.to_csv('exam2.csv', index=False, encoding='UTF-8')

### 5.1.3 ウェブ上の表

my_url = 'https://github.com/taroyabuki/fromzero/blob/master/data/exam.csv'
my_tables = pd.read_html(my_url)

my_tables
#> [   Unnamed: 0 name  english ...
#>  0         NaN    A       60 ...
#>  1         NaN    B       90 ...
#>  2         NaN    C       70 ...
#>  3         NaN    D       90 ...]

my_tables[0]
#>    Unnamed: 0 name  english ...
#> 0         NaN    A       60 ...
#> 1         NaN    B       90 ...
#> 2         NaN    C       70 ...
#> 3         NaN    D       90 ...

# 1列目以降を取り出す．
my_data = my_tables[0].iloc[:, 1:]
my_data
#>   name  english  math gender
#> 0    A       60    70      f
#> 1    B       90    80      m
#> 2    C       70    90      m
#> 3    D       90   100      f

### 5.1.4 JSONとXML

#### 5.1.4.1 JSONデータの読み込み

my_url = ('https://raw.githubusercontent.com/taroyabuki'
          '/fromzero/master/data/exam.json')
my_data = pd.read_json(my_url)
#my_data = pd.read_json('exam.json') # （ファイルを使う場合）
my_data
#>   name  english  math gender
#> 0    A       60    70      f
#> 1    B       90    80      m
#> 2    C       70    90      m
#> 3    D       90   100      f

#### 5.1.4.2 XMLデータの読み込み

import xml.etree.ElementTree as ET
from urllib.request import urlopen

my_url = ('https://raw.githubusercontent.com/taroyabuki'
          '/fromzero/master/data/exam.xml')
with urlopen(my_url) as f:
    my_tree = ET.parse(f)       # XMLデータの読み込み

#my_tree = ET.parse('exam.xml') # （ファイルを使う場合）
my_ns = '{https://www.example.net/ns/1.0}' # 名前空間

my_records = my_tree.findall(f'.//{my_ns}record')

def f(record):
    my_dic1 = record.attrib # 属性を取り出す．
    # 子要素の名前と内容のペアを辞書にする．
    my_dic2 = {child.tag.replace(my_ns, ''): child.text for child in list(record)}
    return {**my_dic1, **my_dic2} # 辞書を結合する．

my_data = pd.DataFrame([f(record) for record in my_records])
my_data['english'] = pd.to_numeric(my_data['english'])
my_data['math']    = pd.to_numeric(my_data['math'])
my_data
#>    english  math gender name
#> 0       60    70      f    A
#> 1       90    80      m    B
#> 2       70    90      m    C
#> 3       90   100      f    D
