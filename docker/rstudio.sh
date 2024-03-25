#!/bin/sh
docker run \
-d \
-e PASSWORD=password \
-e ROOT=TRUE \
-p 8787:8787 \
-v "$(pwd):/home/rstudio/work" \
--platform linux/x86_64 \
--name rs \
taroyabuki/rstudio
