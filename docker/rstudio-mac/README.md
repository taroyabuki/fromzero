# RStudio用のコンテナ（Apple Chip）

Docker Hub: https://hub.docker.com/r/taroyabuki/rstudio-mac

- Apple Chipでは，11章のコードは実行できません．11章を読む際には，Google Colabを使ってください（[R](../code/R-notebook)・[Python](../code/Python-notebook)）．
- 起動スクリプト：[rstudio-mac.sh](../rstudio-mac.sh)
- RStudio Serverへのアクセス：http://localhost:8787

次のようにして起動スクリプトをダウンロードしておけば，`sh rstudio-mac.sh`で起動できます．

```bash
wget https://raw.githubusercontent.com/taroyabuki/rp/master/docker/rstudio-mac.sh
```

`git clone https://github.com/taroyabuki/fromzero.git`の後で，`sh fromzero/docker/rstudio-mac.sh`として起動することもできます．
