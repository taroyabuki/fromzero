[講談社サイエンティフィク](https://www.kspub.co.jp/) ／ [実践Data Scienceシリーズ](https://www.kspub.co.jp/book/series/S069.html) ／ ゼロからはじめるデータサイエンス入門

# ゼロからはじめるデータサイエンス入門（講談社, 2021）サポートサイト

[書店へのリンク集（版元ドットコム）](https://www.hanmoto.com/bd/isbn/9784065132326)

<a href="https://github.com/taroyabuki/fromzero/blob/master/cover.jpg"><img src="https://raw.githubusercontent.com/taroyabuki/fromzero/master/cover.jpg" alt="書影" style="width:300px;"/></a>

著者：**辻真吾**（[@tsjshg](https://twitter.com/tsjshg)）・**矢吹太朗**（[@yabuki](https://twitter.com/yabuki)）

RやPythonのコード（具体的なコンピュータプログラム）の読み書きを通じてデータサイエンスについて学ぶための一冊です．
コードなしで学びたいという人には，別の書籍にあたることをお勧めします．

本書には，次の三つの特徴があります．

1. 第I部「データサイエンスの準備」で，準備に時間をかけています．
1. ほぼ全ての例をコードに基づいて説明しています．本書掲載のコードはサポートサイト（[ここ](#コード)）でも公開しています（使用方法は2.6節を参照）．ただし，コードは自分で入力して実行することを勧めます．
1. 第II部「機械学習」では，ほぼ全ての課題をRとPythonで解決し，同じ結果を得ることを試みています．[画像とそのソースコード](figures)をご参照ください．

## コード

コード|言語|形式|実行環境
--|--|--|--
[R (Google Colab)](code/R-notebook)|R|ノートブック|Google Colab
[R (.ipynb)](code/R-notebook)|R|ノートブック|Jupyter Notebook
[R (.r)](code/R)|R|スクリプト|RStudio
[R Markdown (.Rmd)](code/Rmd)|R|R Markdown|RSturio
[Python (Google Colab)](code/Python-notebook)|Python|ノートブック|Google Colab
[Python (.ipynb)](code/Python-notebook)|Python|ノートブック|Jupyter Notebook
[Python (.py)](code/py)|Python|スクリプト|一般のPython環境

Google Colab以外のコードは，`git clone https://github.com/taroyabuki/fromzero.git`としてから使うことを勧めます（2.6節を参照）．

## [画像とそのソースコード](figures)

## Docker

環境|ハードウェア|説明
--|--|--
Jupyter Notebook||[jupyter](docker/jupyter)
RStudio|Intel, AMD64（GPU無効）|[rstudio](docker/rstudio)
RStudio|Intel, AMD64（GPU有効）|[rstudio-gpu](docker/rstudio-gpu)
RStudio|Apple Silicon|[rstudio-mac](docker/rstudio-mac)
