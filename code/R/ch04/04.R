## 4.1 記述統計

### 4.1.1 平均・分散・標準偏差

x <- c(165, 170, 175, 180, 185)
mean(x) # 平均
#> [1] 175

n <- length(x) # サンプルサイズ
sum(x) / n
#> [1] 175

y <- c(173, 174, 175, 176, 177)
mean(y)
#> [1] 175

var(x) # xの分散
#> [1] 62.5

var(y) # yの分散
#> [1] 2.5

sum((x - mean(x))^2) / (n - 1)
#> [1] 62.5

sd(x) # xの標準偏差
#> [1] 7.905694

sd(y) # yの標準偏差
#> [1] 1.581139

var(x)**0.5 # xの標準偏差
#> [1] 7.905694

psych::describe(x)
#>    vars n mean   sd ...
#> X1    1 5  175 7.91 ...

# あるいは

pastecs::stat.desc(x)
#>      nbr.val ...   std.dev ...
#>    5.0000000 ... 7.9056942 ...

quantile(x)
#>   0%  25%  50%  75% 100%
#>  165  170  175  180  185

#### 4.1.1.1 不偏分散とその非負の平方根

x <- c(165, 170, 175, 180, 185)

var(x)                # 不偏分散
#> [1] 62.5

mean((x - mean(x))^2) # 標本分散
# あるいは
n <- length(x)
var(x) * (n - 1) / n  # 標本分散
#> [1] 50

sd(x)                     # √不偏分散
#> [1] 7.905694

mean((x - mean(x))^2)^0.5 # √標本分散
# あるいは
sd(x) * sqrt((n - 1) / n) # √標本分散
#> [1] 7.071068

sd(x) / length(x)**0.5
#> [1] 3.535534

### 4.1.2 データフレームの統計処理

library(tidyverse)

my_df <- data.frame(
  name    = c("A", "B", "C", "D"),
  english = c( 60,  90,  70,  90),
  math    = c( 70,  80,  90, 100),
  gender  = c("f", "m", "m", "f"))

#### 4.1.2.1 列ごとの集計

var(my_df$english)
#> [1] 225

# 結果はベクタ
my_df[, c(2, 3)] %>% sapply(var)
#> english     math
#> 225.0000 166.6667

# 結果はリスト
my_df[, c(2, 3)] %>% lapply(var)
#> $english
#> [1] 225
#>
#> $math
#> [1] 166.6667

# 結果はデータフレーム
my_df[, c(2, 3)] %>% # 2, 3列目
  summarize(across(  # の
    everything(),    # 全ての
    var))            # 不偏分散
# あるいは
my_df %>%              # データフレーム
  summarize(across(    # の
    where(is.numeric), # 数値の列の
    var))              # 不偏分散
# あるいは
my_df %>%              # データフレーム
  summarize(across(    # の
    where(is.numeric), # 数値の列の
    function(x) { var(x) })) # 不偏分散

#>   english     math
#> 1     225 166.6667

psych::describe(my_df)
#>         vars n mean    sd ...
#> name*      1 4  2.5  1.29 ...
#> english    2 4 77.5 15.00 ...
#> math       3 4 85.0 12.91 ...
#> gender*    4 4  1.5  0.58 ...

# あるいは

pastecs::stat.desc(my_df)
#>          name     english ...
#> nbr.val    NA   4.0000000 ...
#> nbr.null   NA   0.0000000 ...
#> nbr.na     NA   0.0000000 ...
#> min        NA  60.0000000 ...
#> max        NA  90.0000000 ...
# 以下省略

#### 4.1.2.2 分割表とグループごとの集計

table(my_df$gender)

#> f m
#> 2 2

my_df2 <- data.frame(
  gender = my_df$gender,
  excel = my_df$math >= 80)
table(my_df2)

#>       excel
#> gender FALSE TRUE
#>      f     1    1
#>      m     0    2

my_df %>% group_by(gender) %>%
  summarize(across(
    where(is.numeric), mean),
    .groups = "drop") # グループ化解除

#> # A tibble: 2 x 3
#>   gender english  math
#>   <chr>    <dbl> <dbl>
#> 1 f           75    85
#> 2 m           80    85

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
    aes(x = product(w_Sepal, Species)))

f <- function(x) { x^3 - x }
data.frame(x = c(-2, 2)) %>%
  ggplot(aes(x = x)) +
  stat_function(fun = f)

## 4.3 乱数

### 4.3.1 一様乱数（離散）

x <- sample(x = 1:6,        # 範囲
            size = 10000,   # 乱数の数
            replace = TRUE) # 重複あり
hist(x, breaks = 0:6) # ヒストグラム

### 4.3.2 一様乱数（連続）

x <- runif(min = 0,  # 最小
           max = 1,  # 最大
           n = 1000) # 乱数の数
hist(x)

x <- as.integer(      # 整数に変換
  runif(min = 1,      # 最小
        max = 7,      # 最大 + 1
        n = 1000))    # 乱数の数
hist(x, breaks = 0:6) # 結果は割愛

### 4.3.3 二項乱数

n <- 100
p <- 0.5
r <- 10000
x <- rbinom(size = n, # 試行回数
            prob = p, # 確率
            n = r)    # 乱数の数
hist(x, breaks = max(x) - min(x))

### 4.3.4 正規乱数

r <- 10000
x <- rnorm(mean = 50, # 平均
           sd = 5,    # 標準偏差
           n = r)     # 乱数の数
hist(x, breaks = 40)

#### 4.3.4.1 補足：不偏性の具体例

library(tidyverse)

f <- function(k) {
  n <- 10000
  tmp <- replicate(n = n, expr = g(rnorm(n =  k, sd = 3)))
  list(k = k,
       mean = mean(tmp),       # 平均
       se = sd(tmp) / sqrt(n)) # 標準誤差
}

g <- var
c(10, 20, 30) %>% map_dfr(f)
#> # A tibble: 3 x 3
#>       k  mean     se
#>   <dbl> <dbl>  <dbl>
#> 1    10  8.98 0.0427
#> 2    20  8.97 0.0288
#> 3    30  9.03 0.0233

g <- sd
c(5, 10, 15, 20) %>% map_dfr(f)
#> # A tibble: 3 x 3
#>       k  mean      se
#>   <dbl> <dbl>   <dbl>
#> 1    10  2.92 0.00701
#> 2    20  2.95 0.00481
#> 3    30  2.97 0.00394

g <- function(x) {
  n <- length(x)
  sd(x) *
    sqrt((n - 1) / 2) *
    gamma((n - 1) / 2) /
    gamma(n / 2)
}
c(10, 20, 30) %>% map_dfr(f)
#> # A tibble: 3 x 3
#>       k  mean      se
#>   <dbl> <dbl>   <dbl>
#> 1    10  3.00 0.00717
#> 2    20  2.99 0.00488
#> 3    30  3.00 0.00396

## 4.4 統計的推測

### 4.4.1 検定

library(exactci)
library(tidyverse)

a <- 0.05                              # 有意水準
binom.exact(x = 2,                     # 当たった回数
            n = 15,                    # くじを引いた回数
            p = 4 / 10,                # 当たる確率（仮説）
            plot = TRUE,               # p値の描画（結果は次項に掲載）
            conf.level = 1 - a,        # 信頼係数（デフォルト）
            tsmethod = "minlike",      # p値の定義
            alternative = "two.sided") # 両側検定（デフォルト）
                                       # 左片側検定なら'less'
                                       # 右片側検定なら'greater'

#> 	Exact two-sided binomial test (central method)
#>
#> data:  2 and 15
#> number of successes = 2, number of trials = 15,
#> p-value = 0.03646
#> alternative hypothesis: true probability of success is not equal to 0.4
#> 95 percent confidence interval:
#>  0.0242 0.3967
#> sample estimates:
#> probability of success
#>              0.1333333

#### 4.4.1.1 補足：p値とは何か

t <- 4 / 10               # 当たる確率
n <- 15                   # くじを引いた回数
x <- 0:n                  # 当たった回数
my_pr  <- dbinom(x, n, t) # x回当たる確率
my_pr2 <- dbinom(2, n, t) # 2回当たる確率

my_data <- data.frame(x = x,
                      probability = my_pr,
                      color = my_pr <= my_pr2) # 当たる確率が，2回当たる確率以下

my_data %>% ggplot(aes(x = x, y = probability, color = color)) +
  geom_point(size = 3) +
  geom_linerange(aes(ymin = 0, ymax = probability), ) + # 垂直線
  geom_hline(yintercept = my_pr2) +                     # 水平線
  theme(legend.position = "none")                       # 凡例を表示しない．

### 4.4.2 推定

# 前項の結果（再掲）
#> 95 percent confidence interval:
#>  0.0242 0.3967

# 前項冒頭のコード

### 4.4.3 平均の差の検定と推定（t検定）

X <- c(32.1, 26.2, 27.5, 31.8, 32.1, 31.2, 30.1, 32.4, 32.3, 29.9,
       29.6, 26.6, 31.2, 30.9, 29.3)
Y <- c(35.4, 34.6, 31.1, 32.4, 33.3, 34.7, 35.3, 34.3, 32.1, 28.3,
       33.3, 30.5, 32.6, 33.3, 32.2)

t.test(x = X, y = Y,
       conf.level = 0.95,         # 信頼係数（デフォルト）
       paired = TRUE,             # 対標本である．
       alternative = "two.sided") # 両側検定（デフォルト）
                                  # 左片側検定なら'less'
                                  # 右片側検定なら'greater'

#> 	Paired t-test
#>
#> data:  X and Y
#> t = -4.3694, df = 14, p-value = 0.0006416
#> alternative hypothesis: true difference in means is not equal to 0
#> 95 percent confidence interval:
#>  -3.995525 -1.364475
#> sample estimates:
#> mean of the differences
#>                   -2.68

t.test(x = X, y = Y,
       paired = FALSE,   # 対標本ではない（デフォルト）．
       var.equal = TRUE, # 等分散を仮定する．仮定しないならFALSE（デフォルト）．
       alternative = "two.sided",
       conf.level = 0.95)

#> 	Two Sample t-test
#>
#> data:  X and Y
#> t = -3.6821, df = 28, p-value = 0.0009785
#> alternative hypothesis: true difference in means is not equal to 0
#> 95 percent confidence interval:
#>  -4.170906 -1.189094
#> sample estimates:
#> mean of x mean of y
#>  30.21333  32.89333

### 4.4.4 独立性の検定（カイ2乗検定）

my_url <- str_c("https://raw.githubusercontent.com/taroyabuki",
                "/fromzero/master/data/smoker.csv")
my_data <- read_csv(my_url)

head(my_data)
#>   alive smoker
#> 1   Yes     No
#> 2   Yes     No
#> 3   Yes     No
#> 4   Yes     No
#> 5   Yes     No
#> 6   Yes     No

my_table <- table(my_data)
my_table
#>      smoker
#> alive  No Yes
#>   No  117  54
#>   Yes 950 348

chisq.test(my_table, correct = FALSE)

#> 	Pearson's Chi-squared test
#>
#> data:  my_data
#> X-squared = 1.7285, df = 1, p-value = 0.1886

### 4.4.5 ブートストラップ

#### 4.4.5.1 15回引いて2回当たったくじ

X <- rep(0:1, c(13, 2)) # 手順1
X
#> [1] 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1

tmp <- sample(X, size = length(X), replace = TRUE) # 手順2
tmp
#> [1] 0 0 1 0 0 0 0 0 0 1 0 1 0 0 0

sum(tmp) # 手順3
#> [1] 2

n <- 10^5
result <- replicate(n, sum(sample(X, size = length(X), replace = TRUE))) # 手順4

hist(x = result, breaks = 0:15,
     right = FALSE)

quantile(result, c(0.025, 0.975))
#>  2.5% 97.5%
#>     0     5

