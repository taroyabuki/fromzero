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

#### 4.4.5.2 平均の差の信頼区間

X <- c(32.1, 26.2, 27.5, 31.8, 32.1, 31.2, 30.1, 32.4, 32.3, 29.9,
       29.6, 26.6, 31.2, 30.9, 29.3)
Y <- c(35.4, 34.6, 31.1, 32.4, 33.3, 34.7, 35.3, 34.3, 32.1, 28.3,
       33.3, 30.5, 32.6, 33.3, 32.2)
Z <- X - Y # 対標本として扱う．

n <- 10^5
result <- replicate(n, mean(sample(Z, length(Z), replace = TRUE)))

quantile(result, c(0.025, 0.975))
#>      2.5%     97.5%
#> -3.880000 -1.566667

hist(result)

result <- replicate(n,
                    mean(sample(X, length(X), replace = TRUE)) -
                    mean(sample(Y, length(Y), replace = TRUE)))
quantile(result, c(0.025, 0.975))
#>      2.5%     97.5%
#> -4.053333 -1.306667
