pdf(file = "13-r-heatmap.pdf", width = 6, height = 5.5)

library(tidyverse)

my_data <- data.frame(
  language  = c(  0,  20,  20,  25,  22,  17),
  english   = c(  0,  20,  40,  20,  24,  18),
  math      = c(100,  20,   5,  30,  17,  25),
  science   = c(  0,  20,   5,  25,  16,  23),
  society   = c(  0,  20,  30,   0,  21,  17),
  row.names = c("A", "B", "C", "D", "E", "F"))

my_data %>% scale %>% # 列ごとの標準化
  gplots::heatmap.2(cexRow = 1, cexCol = 1) # ラベルのサイズを指定して描画する．
