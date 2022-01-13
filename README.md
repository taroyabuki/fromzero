[講談社サイエンティフィク](https://www.kspub.co.jp/) ／ [実践Data Scienceシリーズ](https://www.kspub.co.jp/book/series/S069.html) ／ [ゼロからはじめるデータサイエンス入門](https://www.kspub.co.jp/book/detail/5132326.html)

# ゼロからはじめるデータサイエンス入門（講談社, 2021）サポートサイト

[書店へのリンク集（版元ドットコム）](https://www.hanmoto.com/bd/isbn/9784065132326)

<a href="https://github.com/taroyabuki/fromzero/blob/master/cover.jpg"><img src="https://raw.githubusercontent.com/taroyabuki/fromzero/master/cover.jpg" alt="書影" style="width:300px;"/></a>

著者：**辻真吾**（[@tsjshg](https://twitter.com/tsjshg)）・**矢吹太朗**（[@yabuki](https://twitter.com/yabuki)）

RやPythonのコード（具体的なコンピュータプログラム）の読み書きを通じてデータサイエンスについて学ぶための一冊です．
コードなしで学びたいという人には，別の書籍にあたることをお勧めします．

本書には，次の三つの特徴があります．

1. 第1部「データサイエンスの準備」で，準備に時間をかけています．
1. ほぼ全ての例をコードに基づいて説明しています．本書掲載のコードはサポートサイト（[ここ](#コード)）でも公開しています（使用方法は2.6節を参照）．
1. 第2部「機械学習」では，ほぼ全ての課題をRとPythonで解決し，同じ結果を得ることを試みています．

## [更新情報・正誤表](update.md)

## 目次

内容を想像していただけるように，ドラフト版の画像をリンク先に掲載しています．

- [はじめに](figures#はじめに)
- 第1部
    - [第1章 コンピュータとネットワーク](figures#第1章-コンピュータとネットワーク)
    - [第2章 データサイエンスのための環境](figures#第2章-データサイエンスのための環境)
    - [第3章 RとPython](figures#第3章-RとPython)
    - [第4章 統計入門](figures#第4章-統計入門)
    - 第5章 前処理
- 第2部
    - [第6章 機械学習の目的・データ・手法](figures#第6章-機械学習の目的データ手法)
    - [第7章 回帰1（単回帰）](figures#第7章-回帰1単回帰)
    - [第8章 回帰2（重回帰）](figures#第8章-回帰2重回帰)
    - [第9章 分類1（多値分類）](figures#第9章-分類1多値分類)
    - [第10章 分類2（2値分類）](figures#第10章-分類22値分類)
    - [第11章 深層学習とAutoML](figures#第11章-深層学習とAutoML)
    - [第12章 時系列予測](figures#第12章-時系列予測)
    - [第13章 教師なし学習](figures#第13章-教師なし学習)
- [付録A 環境構築](figures#付録A-環境構築)
- [おわりに](figures#おわりに)
- 参考文献
- 索引

## コード

コード|言語|形式|実行環境
--|--|--|--
[R (Google Colab)](code/R-notebook)|R|ノートブック|Google Colab
[R (.ipynb)](code/R-notebook)|R|ノートブック|Jupyter Notebook
[R (.r)](code/R)|R|スクリプト|RStudio
[R Markdown (.Rmd)](code/Rmd)|R|R Markdown|RStudio
[Python (Google Colab)](code/Python-notebook)|Python|ノートブック|Google Colab
[Python (.ipynb)](code/Python-notebook)|Python|ノートブック|Jupyter Notebook
[Python (.py)](code/py)|Python|スクリプト|一般のPython環境

コードの使い方は，2.6節を参照してください．

## [画像とそのソースコード](figures)

## Docker

環境|ハードウェア|説明
--|--|--
Jupyter Notebook|Intel, AMD64, Apple Chip（GPU無効）|[jupyter](docker/jupyter)
RStudio|Intel, AMD64（GPU無効）|[rstudio](docker/rstudio)
RStudio|Intel, AMD64（NVIDIAのGPU）|[rstudio-gpu](docker/rstudio-gpu)
RStudio|Apple Chip|[rstudio-mac](docker/rstudio-mac)

Dockerの使い方は，2.3節を参照してください．
