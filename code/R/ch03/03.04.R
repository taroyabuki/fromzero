## 3.4 データフレーム

### 3.4.1 データフレームの作成

library(tidyverse)

#### 3.4.1.1 データを列ごとに記述する方法

my_df <- data.frame(
  name    = c("A", "B", "C", "D"),
  english = c( 60,  90,  70,  90),
  math    = c( 70,  80,  90, 100),
  gender  = c("f", "m", "m", "f"))

#### 3.4.1.2 データを見た目のとおりに記述する方法

my_df <- tribble(
  ~name, ~english, ~math, ~gender,
  "A",         60,    70,     "f",
  "B",         90,    80,     "m",
  "C",         70,    90,     "m",
  "D",         90,   100,     "f")

head(my_df)
# 結果は割愛

#### 3.4.1.3 データフレームのサイズ

dim(my_df)  # 行数と列数
#> [1] 4 4

nrow(my_df) # 行数
#> [1] 4

ncol(my_df) # 列数
#> [1] 4

#### 3.4.1.4 組合せ

my_df2 <- expand.grid(
  X = c(1, 2, 3),
  Y = c(10, 100))
my_df2
#>   X   Y
#> 1 1  10
#> 2 2  10
#> 3 3  10
#> 4 1 100
#> 5 2 100
#> 6 3 100

#### 3.4.1.5 列と行の名前

colnames(my_df2)
#> [1] "X" "Y"

colnames(my_df2) <- c("P", "Q")
my_df2
#>   P   Q
#> 1 1  10
#> 2 2  10
# 以下省略

row.names(my_df)
#> [1] "1" "2" "3" "4"

row.names(my_df2) <-
  c("a", "b", "c", "d", "e", "f")
my_df2
#>   P   Q
#> a 1  10
#> b 2  10
#> c 3  10
# 以下省略

my_df3 <- data.frame(
  english =   c( 60,  90,  70,  90),
  math    =   c( 70,  80,  90, 100),
  gender  =   c("f", "m", "m", "f"),
  row.names = c("A", "B", "C", "D"))
my_df3
#>   english math gender
#> A      60   70      f
#> B      90   80      m
#> C      70   90      m
#> D      90  100      f

### 3.4.2 データの追加

#### 3.4.2.1 行の追加（データフレームの結合）

tmp <- data.frame(
  name    = "E",
  english =  80,
  math    =  80,
  gender  = "m")
my_df2 <- rbind(my_df, tmp)

#### 3.4.2.2 列の追加

my_df2 <- my_df %>%
  mutate(id = c(1, 2, 3, 4))

my_df3 <- my_df               # コピー
my_df3["id"] <- c(1, 2, 3, 4) # 更新
my_df3 # 結果の確認（割愛）

### 3.4.3 データの取り出し

#### 3.4.3.1 観測値の取り出し

my_df[1, 2]
#> [1] 60

#### 3.4.3.2 1列の取り出し（結果は1次元データ）

x <- my_df[, 2]
# あるいは
x <- my_df$english
# あるいは
x <- my_df$"english"
# あるいは
x <- my_df[["english"]]
# あるいは
tmp <- "english"
x <- my_df[[tmp]]

x # 結果の確認（割愛）

#### 3.4.3.3 複数列の取り出し（結果はデータフレーム）

x <- my_df %>% select(name, math)

x <- my_df[, c(1, 3)]

x <- my_df %>%
  select(-c(english, gender))
# あるいは
x <- my_df[, -c(2, 4)]

#### 3.4.3.4 複数行の取り出し（結果はデータフレーム）

x <- my_df[c(1, 3), ]

x <- my_df[-c(2, 4), ]

#### 3.4.3.5 検索

x <- my_df[my_df$gender == "m", ]
# あるいは
x <- my_df %>% filter(gender == "m")

x <- my_df[my_df$english > 80 & my_df$gender == "m", ]
# あるいは
x <- my_df %>% filter(english > 80 & gender == "m")

x <- my_df[my_df$english == max(my_df$english), ]
# あるいは
x <- my_df %>% filter(english == max(my_df$english))

my_df2 <- my_df # コピー
my_df2[my_df$gender == "m", ]$gender <- "M"

my_df2
#>   name english math gender
#> 1    A      60   70      f
#> 2    B      90   80      M
#> 3    C      70   90      M
#> 4    D      90  100      f

#### 3.4.3.6 並べ替え

x <- my_df %>% arrange(english)

x <- my_df %>% arrange(-english)

### 3.4.4 補足：行列

#### 3.4.4.1 行列の生成

x <- c(2, 3, 5, 7, 11, 13, 17, 19, 23,
       29, 31, 37)
A <- matrix(
  data = x,     # 1次元データ
  nrow = 3,     # 行数
  byrow = TRUE) # 行ごとの生成
A
#>      [,1] [,2] [,3] [,4]
#> [1,]    2    3    5    7
#> [2,]   11   13   17   19
#> [3,]   23   29   31   37

#### 3.4.4.2 データフレームと行列

A <- my_df[, c(2, 3)] %>% as.matrix
A
#>      english math
#> [1,]      60   70
#> [2,]      90   80
#> [3,]      70   90
#> [4,]      90  100

as.data.frame(A)
#>   english math
#> 1      60   70
#> 2      90   80
#> 3      70   90
#> 4      90  100

#### 3.4.4.3 行列の変形

t(A)
#>         [,1] [,2] [,3] [,4]
#> english   60   90   70   90
#> math      70   80   90  100

#### 3.4.4.4 行列の積

t(A) %*% A
#>         english  math
#> english   24700 26700
#> math      26700 29400

### 3.4.5 縦型と横型

my_wider <- data.frame(
  day = c(25, 26, 27),
  min = c(20, 21, 15),
  max = c(24, 27, 21))

my_longer <- my_wider %>%
  pivot_longer(-day)
my_longer
#> # A tibble: 6 x 3
#>     day name  value
#>   <dbl> <chr> <dbl>
#> 1    25 min      20
#> 2    25 max      24
#> 3    26 min      21
#> 4    26 max      27
#> 5    27 min      15
#> 6    27 max      21

my_longer %>% pivot_wider()
#> # A tibble: 3 x 3
#>     day   min   max
#>   <dbl> <dbl> <dbl>
#> 1    25    20    24
#> 2    26    21    27
#> 3    27    15    21

my_longer %>%
  ggplot(aes(x = day, y = value,
             color = name)) +
  geom_point() +
  geom_line() +
  ylab("temperature") + # y軸ラベル
  scale_x_continuous(
    breaks = my_longer$day) # x軸目盛り
