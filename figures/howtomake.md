# 画像の生成方法

コンテナjupyterかrstudioを使います（コンテナの生成方法は2.3節を参照）．

```bash
docker exec -it jr bash
# あるいは
docker exec -it rs bash
```

以下はコンテナでの作業です．

## 準備

```bash
apt update && apt install -y texlive-extra-utils pdf2svg

#cd work # 結果をホスト側に保存する場合
git clone https://github.com/taroyabuki/fromzero.git
cd fromzero/figures
```

画像（PDFとSVG）を作ります．
`-j`のあとの数値はCPUコアの数程度にしてください．
ファイル（`*.R`や`*.py`）を更新したら，`make`以下を実行します．
更新されたものだけが，再生成されます．


## Rの図を作る場合

```bash
cd fig-r
#make clean # すべて生成し直す場合
make -j
cd ..
```

## Pythonの図を作る場合

```bash
cd fig-p
#make clean # すべて生成し直す場合
make -j
cd ..
```
