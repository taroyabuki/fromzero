## 4.2 データの可視化

head(iris)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa

### 4.2.1 ヒストグラム

hist(iris$Sepal.Length)

x <- c(10, 20, 30)
hist(x, breaks = 2) # 階級数は2

x <- iris$Sepal.Length
tmp <- seq(min(x), max(x),
           length.out = 10)
hist(x, breaks = tmp, right = FALSE)

### 4.2.2 散布図

plot(iris$Sepal.Length,
     iris$Sepal.Width)

### 4.2.3 箱ひげ図

boxplot(iris[, -5])

### 4.2.4 棒グラフとエラーバー

library(tidyverse)
my_df <- psych::describe(iris[, -5])
my_df %>% select(mean, sd, se)
#>              mean   sd   se
#> Sepal.Length 5.84 0.83 0.07
#> Sepal.Width  3.06 0.44 0.04
#> Petal.Length 3.76 1.77 0.14
#> Petal.Width  1.20 0.76 0.06

tmp <- rownames(my_df)
my_df %>% ggplot(aes(x = factor(tmp, levels = tmp), y = mean)) +
  geom_col() +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se)) +
  xlab(NULL)

my_group <- iris %>% group_by(Species)       # 品種ごとに，

my_df <- my_group %>%                        # 各変数の，平均と
  summarize(across(everything(), mean)) %>%
  pivot_longer(-Species)

tmp <- my_group %>%                          # 標準誤差を求める．
  summarize(across(everything(), ~ sd(.) / length(.)**0.5)) %>%
  pivot_longer(-Species)

my_df$se <- tmp$value
head(my_df)
#> # A tibble: 6 x 4
#>   Species    name         value     se
#>   <fct>      <chr>        <dbl>  <dbl>
#> 1 setosa     Sepal.Length 5.01  0.0498
#> 2 setosa     Sepal.Width  3.43  0.0536
#> 3 setosa     Petal.Length 1.46  0.0246
#> 4 setosa     Petal.Width  0.246 0.0149
#> 5 versicolor Sepal.Length 5.94  0.0730
#> 6 versicolor Sepal.Width  2.77  0.0444

my_df %>%
  ggplot(aes(x = Species, y = value, fill = name)) +
  geom_col(position = "dodge") +
  geom_errorbar(aes(ymin = value - se, ymax = value + se), position = "dodge")

# 各変数の平均
iris %>% pivot_longer(-Species) %>%
  ggplot(aes(x = name, y = value)) +
  geom_bar(stat = "summary", fun = mean) +
  stat_summary(geom = "errorbar", fun.data = mean_se) +
  xlab(NULL)

# 各変数の平均（品種ごと）
iris %>% pivot_longer(-Species) %>%
  ggplot(aes(x = Species, y = value, fill = name)) +
  geom_bar(stat = "summary", fun = mean, position = "dodge") +
  stat_summary(geom = "errorbar", fun.data = mean_se, position = "dodge")

### 4.2.5 モザイクプロット

my_df <- data.frame(
  Species = iris$Species,
  w_Sepal = iris$Sepal.Width > 3)
table(my_df) # 分割表
#>             w_Sepal
#> Species      FALSE TRUE
#>   setosa         8   42
#>   versicolor    42    8
#>   virginica     33   17

mosaicplot(
  formula = ~ Species + w_Sepal,
  data = my_df)

library(vcd)
vcd::mosaic(formula = ~w_Sepal + Species, data = my_df,
            labeling = labeling_values)

### 4.2.6 関数のグラフ

curve(x^3 - x, -2, 2)

### 4.2.7 ggplot2 (R)

x <- iris$Sepal.Length
tmp <- seq(min(x), max(x),
           length.out = 10)
iris %>%
  ggplot(aes(x = Sepal.Length)) +
  geom_histogram(breaks = tmp,
                 closed = "left")

iris %>%
  ggplot(aes(x = Sepal.Length,
             y = Sepal.Width)) +
  geom_point()

iris %>%
  pivot_longer(-Species) %>%
  ggplot(aes(
    x = factor(name,
               levels = names(iris)),
    y = value)) +
  geom_boxplot() +
  xlab(NULL)

library(ggmosaic)
my_df <- data.frame(
  Species = iris$Species,
  w_Sepal = iris$Sepal.Width > 3)
my_df %>%
  ggplot() +
  geom_mosaic(
    aes(x = product(w_Sepal,
                    Species)))

f <- function(x) { x^3 - x }
data.frame(x = c(-2, 2)) %>%
  ggplot(aes(x = x)) +
  stat_function(fun = f)
