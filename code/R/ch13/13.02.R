## 13.2 クラスタ分析

### 13.2.1 階層的クラスタ分析

library(tidyverse)

my_data <- data.frame(
  x         = c(  0, -16,  10,  10),
  y         = c(  0,   0,  10, -15),
  row.names = c("A", "B", "C", "D"))

my_result <- my_data %>%
  dist("euclidian") %>% # distだけでも可
  hclust("complete")    # hclustだけでも可

my_result %>% factoextra::fviz_dend(
  k = 3, # クラスタ数
  rect = TRUE, rect_fill = TRUE)

my_result %>% factoextra::fviz_dend(
  k = 3,
  rect = TRUE, rect_fill = TRUE,
  type = "phylogenic")

my_result %>% cutree(3)
#> A B C D
#> 1 2 1 3

### 13.2.2 階層的クラスタ分析とヒートマップ

library(tidyverse)

my_data <- data.frame(
  language  = c(  0,  20,  20,  25,  22,  17),
  english   = c(  0,  20,  40,  20,  24,  18),
  math      = c(100,  20,   5,  30,  17,  25),
  science   = c(  0,  20,   5,  25,  16,  23),
  society   = c(  0,  20,  30,   0,  21,  17),
  row.names = c("A", "B", "C", "D", "E", "F"))

try( # RMarkdownで発生するエラーを回避する．
  my_data %>% scale %>%                        # 列ごとの標準化
    gplots::heatmap.2(cexRow = 1, cexCol = 1), # ラベルのサイズを指定して描画する．
  silent = TRUE)

### 13.2.3 非階層的クラスタ分析

library(tidyverse)

my_data <- data.frame(
  x         = c(  0, -16,  10,  10),
  y         = c(  0,   0,  10, -15),
  row.names = c("A", "B", "C", "D"))

my_result <- my_data %>% kmeans(3)

my_result$cluster
#> A B C D
#> 2 3 2 1

### 13.2.4 クラスタ数の決定

library(tidyverse)
library(factoextra)

my_data <- iris[, -5]

f <- 2:5 %>% map(function(k) {
  my_data %>% kmeans(k) %>%
    fviz_cluster(data = my_data, geom = "point") +
    ggtitle(sprintf("k = %s", k))
})
gridExtra::grid.arrange(f[[1]], f[[2]], f[[3]], f[[4]], ncol = 2)

fviz_nbclust(my_data, kmeans, method = "wss")

### 13.2.5 主成分分析とクラスタ分析

library(tidyverse)
my_data <- iris[, -5] %>% scale

my_result <- prcomp(my_data)$x %>% as.data.frame # 主成分分析

# 非階層的クラスタ分析の場合
my_result$cluster <- (my_data %>% scale %>% kmeans(3))$cluster %>% as.factor

# 階層的クラスタ分析の場合
#my_result$cluster <- my_data %>% dist %>% hclust %>% cutree(3) %>% as.factor

my_result %>%
  ggplot(aes(x = PC1, y = PC2, color = cluster)) + # 色でクラスタを表現する．
  geom_point(shape = iris$Species) +               # 形で品種を表現する．
  theme(legend.position = "none")
