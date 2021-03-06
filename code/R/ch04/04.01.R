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
