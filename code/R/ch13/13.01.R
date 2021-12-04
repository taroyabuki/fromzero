## 13.1 主成分分析

library(tidyverse)

my_data <- data.frame(
  language  = c(  0,  20,  20,  25,  22,  17),
  english   = c(  0,  20,  40,  20,  24,  18),
  math      = c(100,  20,   5,  30,  17,  25),
  science   = c(  0,  20,   5,  25,  16,  23),
  society   = c(  0,  20,  30,   0,  21,  17),
  row.names = c("A", "B", "C", "D", "E", "F"))
my_result <- my_data %>% prcomp # 主成分分析の実行

my_result$x # 主成分スコア
#>          PC1        PC2 ...
#> A -74.907282  -7.010808 ...
#> B  13.818842   2.753459 ...
#> C  33.714034 -18.417290 ...
#> D   1.730630  17.876372 ...
#> E  17.837474  -1.064998 ...
#> F   7.806303   5.863266 ...

my_result %>% ggbiplot::ggbiplot(
  labels = row.names(my_data),
  scale = 0)

my_result$rotation %>% t
#>       language    english         math    science    society
#> PC1  0.2074983  0.3043604 -0.887261240  0.1301984  0.2452041
#> PC2  0.2794627 -0.3250521 -0.097642669  0.7026667 -0.5594347
#> PC3 -0.3061175 -0.6157986 -0.056345381  0.3384462  0.6398152
#> PC4  0.7649426 -0.4716969 -0.007654992 -0.4180454  0.1324548
#> PC5  0.4472136  0.4472136  0.447213595  0.4472136  0.4472136

summary(my_result)
#> Importance of components:
#>                            PC1      PC2     PC3     PC4       PC5
#> Standard deviation     38.2644 12.25566 5.58845 1.52970 1.232e-15
#> Proportion of Variance  0.8885  0.09115 0.01895 0.00142 0.000e+00
#> Cumulative Proportion   0.8885  0.97963 0.99858 1.00000 1.000e+00

### 13.1.1 標準化＋主成分分析

my_result <- prcomp(
  x = my_data,
  scale = TRUE)       # 標準化
# あるいは
my_result <- prcomp(
  x = scale(my_data)) # 標準化データ

my_result$x # 主成分スコア
#>          PC1        PC2 ...
#> A -3.6737215 -0.5688501 ...
#> B  0.6528793  0.2469258 ...
#> C  1.5682936 -1.7425981 ...
#> D  0.2505043  1.6400394 ...
#> E  0.8861864 -0.1104931 ...
#> F  0.3158579  0.5349762 ...

### 13.1.2 補足：行列計算による再現

Z  <- my_data %>% scale(scale = FALSE) %>% as.matrix # 標準化しない場合
#Z <- my_data %>% scale(scale = TRUE)  %>% as.matrix # 標準化する場合

n <- nrow(my_data)
S <- var(Z)                          # 分散共分散行列
#S <- t(Z) %*% Z / (n - 1)           # （同じ結果）
tmp <- eigen(S)                      # 固有値と固有ベクトル
Z %*% tmp$vectors                    # 主成分スコア（結果は割愛）
cumsum(tmp$values) / sum(tmp$values) # 累積寄与率
#> [1] 0.8884833 0.9796285 0.9985801 1.0000000 1.0000000

udv <- svd(Z) # 特異値分解
U <- udv$u
d <- udv$d
V <- udv$v
W <- diag(d)

c(all.equal(Z, U %*% W %*% t(V), check.attributes = FALSE), # 確認1
  all.equal(t(U) %*% U, diag(dim(U)[2])),                   # 確認2
  all.equal(t(V) %*% V, diag(dim(V)[2])))                   # 確認3
#> [1] TRUE TRUE TRUE

U %*% W            # 主成分スコア（結果は割愛）

e <- d^2 / (n - 1) # 分散共分散行列の固有値
cumsum(e) / sum(e) # 累積寄与率
#> [1] 0.8884833 0.9796285 0.9985801 1.0000000 1.0000000
