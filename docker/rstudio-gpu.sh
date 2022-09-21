#!/bin/sh
docker run \
--gpus all \
-d \
-e PASSWORD=password \
-e ROOT=TRUE \
-p 8787:8787 \
-v "$(pwd):/home/rstudio/work" \
--name rs \
taroyabuki/rstudio-gpu
