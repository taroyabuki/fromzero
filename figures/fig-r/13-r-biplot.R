pdf(file = "13-r-biplot.pdf", width = 5.83, height = 4.13)

library(tidyverse)

my_data <- data.frame(
  language = c(  0, 20, 20, 25, 22, 17),
  english  = c(  0, 20, 40, 20, 24, 18),
  math     = c(100, 20,  5, 30, 17, 25),
  science  = c(  0, 20,  5, 25, 16, 23),
  society  = c(  0, 20, 30,  0, 21, 17))
row.names(my_data) <- c("A", "B", "C", "D", "E", "F")

my_result <- my_data %>% prcomp # 主成分分析（標準化なし）

my_result %>% ggbiplot::ggbiplot(labels = row.names(my_data), scale = 0)
