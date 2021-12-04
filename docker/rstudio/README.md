# RStudio用のコンテナ

Docker Hub: https://hub.docker.com/r/taroyabuki/rstudio

- 起動スクリプト：[rstudio.sh](../rstudio.sh)
- RStudio Serverへのアクセス：http://localhost:8787

次のようにして起動スクリプトをダウンロードしておけば，`sh rstudio.sh`で起動できます．

```bash
wget https://raw.githubusercontent.com/taroyabuki/rp/master/docker/rstudio.sh
```

`git clone https://github.com/taroyabuki/fromzero.git`の後で，`sh fromzero/docker/rstudio.sh`として起動することもできます．
