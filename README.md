[講談社サイエンティフィク](https://www.kspub.co.jp/) ／ [実践Data Scienceシリーズ](https://www.kspub.co.jp/book/series/S069.html) ／ [ゼロからはじめるデータサイエンス入門](https://www.kspub.co.jp/book/detail/5132326.html)

# ゼロからはじめるデータサイエンス入門（講談社, 2021）サポートサイト

[書店へのリンク集（版元ドットコム）](https://www.hanmoto.com/bd/isbn/9784065132326)

<img src="https://www.kspub.co.jp/book/detail/images/8e2cee80a3e43a0cbbecef67a945b93613c656b0.jpg" alt="書影" style="width:300px;"/>

著者：**辻真吾**（[@tsjshg](https://twitter.com/tsjshg)）・**矢吹太朗**（[@yabuki](https://twitter.com/yabuki)）

RやPythonのコード（具体的なコンピュータプログラム）の読み書きを通じてデータサイエンスについて学ぶための一冊です．
コードなしで学びたいという人には，別の書籍にあたることをお勧めします．

本書には，次の三つの特徴があります．

1. 第1部「データサイエンスの準備」で，準備に時間をかけています．
1. ほぼ全ての例をコードに基づいて説明しています．本書掲載のコードはサポートサイト（[ここ](#コード)）でも公開しています（使用方法は2.6節を参照）．
1. 第2部「機械学習」では，ほぼ全ての課題をRとPythonで解決し，同じ結果を得ることを試みています．

## [更新情報・正誤表](update.md)

## 目次

- はじめに
- 第1部
    - 第1章 コンピュータとネットワーク
    - 第2章 データサイエンスのための環境
    - 第3章 RとPython
    - 第4章 統計入門
    - 第5章 前処理
- 第2部
    - 第6章 機械学習の目的・データ・手法
    - 第7章 回帰1（単回帰）
    - 第8章 回帰2（重回帰）
    - 第9章 分類1（多値分類）
    - 第10章 分類2（2値分類）
    - 第11章 深層学習とAutoML
    - 第12章 時系列予測
    - 第13章 教師なし学習
- 付録A 環境構築
- おわりに
- 参考文献
- 索引

## コード

言語|システム|コード|実行結果
--|--|--|--
R|Google Colab|[![Open in Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/taroyabuki/fromzero/blob/master/code/r.ipynb)|[![Open in Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/taroyabuki/fromzero/blob/master/code/r-results.ipynb)
R|Jupyter|[r.ipynb](code/r.ipynb)|[r-results.ipynb](code/r-results.ipynb)
R|R Markdown|[r.Rmd](code/r.Rmd)|[r.html](https://taroyabuki.github.io/fromzero/r.html)
Python|Google Colab|[![Open in Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/taroyabuki/fromzero/blob/master/code/python.ipynb)|[![Open in Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/taroyabuki/fromzero/blob/master/code/python-results.ipynb)
Python|Jupyter|[python.ipynb](code/python.ipynb)|[python-results.ipynb](code/python-results.ipynb)
Python|R Markdown|[python.Rmd](code/python.Rmd)|[python.html](https://taroyabuki.github.io/fromzero/python.html)

コードの使い方は，2.6節を参照してください[^1]．

[^1]: [Amazon SageMaker Studio Lab](https://github.com/taroyabuki/fromzero/tree/main/addendum/sagemaker)での動作も確認済みです．

## Docker

環境|言語|説明
--|--|--
Jupyter Notebook|R, Python|[Jupyter Notebook](docker/jupyter)
RStudio|R|[rstudio](docker/rstudio)

Dockerの使い方は，2.3節を参照してください．

## [画像とそのソースコード](figures)

## ライセンス

The contents of https://github.com/taroyabuki/fromzero by Shingo Tsuji and Taro Yabuki is licensed under the [Apache License, Version 2.0](LICENSE).
