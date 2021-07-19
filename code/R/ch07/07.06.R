## 7.6 検証

### 7.6.1 訓練データ・検証データ・テストデータ

### 7.6.2 検証とは何か

### 7.6.3 検証の実践

library(caret)
library(tidyverse)
my_data <- cars
my_model <- train(form = dist ~ speed, data = my_data, method = "lm")

my_model$results
#>   intercept    RMSE  Rsquared      MAE   RMSESD RsquaredSD    MAESD
#> 1      TRUE 16.0206 0.6662176 12.14701 2.518604 0.09249158 1.920564

my_model <- train(form = dist ~ speed, data = my_data, method = "lm",
                  trControl = trainControl(method = "cv", number = 5))
my_model$results
#>   intercept     RMSE  Rsquared      MAE  RMSESD RsquaredSD    MAESD
#> 1      TRUE 15.06708 0.6724501 12.12448 4.75811  0.1848932 3.052435

my_model <- train(form = dist ~ speed, data = my_data, method = "lm",
                  trControl = trainControl(method = "LOOCV"))
my_model$results
#>   intercept     RMSE  Rsquared      MAE
#> 1      TRUE 15.69731 0.6217139 12.05918

### 7.6.4 検証の並列化

library(doParallel)
cl <- makeCluster(detectCores())
registerDoParallel(cl)

### 7.6.5 指標のまとめ

#### 7.6.5.1 準備

library(caret)
library(tidyverse)
my_data <- cars
my_model <- train(form = dist ~ speed, data = my_data, method = "lm")
y  <- my_data$dist
y_ <- my_model %>% predict(my_data)

#### 7.6.5.2 当てはまりの良さの指標

# RMSE（訓練）
RMSE(y_, y)
#> [1] 15.06886

# 決定係数1（訓練）
R2(pred = y_, obs = y,
   form = "traditional")
#> [1] 0.6510794

# 決定係数6（訓練）
R2(pred = y_, obs = y,
   form = "corr")
#> [1] 0.6510794

postResample(pred = y_, obs = y)
#>       RMSE   Rsquared        MAE
#> 15.0688560  0.6510794 11.5801191

#### 7.6.5.3 予測性能の指標（簡単に求められるもの）

my_model <- train(form = dist ~ speed, data = my_data, method = "lm")
my_model$results
#>   intercept     RMSE  Rsquared      MAE ...
#> 1      TRUE 14.88504 0.6700353 11.59226 ...
# 左から，RMSE（検証），決定係数6（検証），MAE（検証）

#### 7.6.5.4 予測性能の指標（RとPythonで同じ結果を得る）

my_model <- train(form = dist ~ speed, data = my_data, method = "lm",
                  trControl = trainControl(method = "LOOCV"))

# 方法1
my_model$results
#>   intercept     RMSE  Rsquared      MAE
#> 1      TRUE 15.69731 0.6217139 12.05918

# 方法2
y  <- my_model$pred$obs
y_ <- my_model$pred$pred
mean((y - y_)^2)**0.5
#> [1] 15.69731

mean(((y - y_)^2)**0.5)
#> [1] 12.05918

### 7.6.6 補足：検証による手法の比較

library(caret)
library(tidyverse)
my_data <- cars

my_lm_model <- train(form = dist ~ speed, data = my_data, method = "lm",
                     trControl = trainControl(method = "LOOCV"))

my_knn_model <- train(form = dist ~ speed, data = my_data, method = "knn",
                      tuneGrid = data.frame(k = 5),
                      trControl = trainControl(method = "LOOCV"))

my_lm_model$results$RMSE
#> [1] 15.69731 # 線形回帰分析

my_knn_model$results$RMSE
#> [1] 15.79924 # K最近傍法

y     <- my_data$dist
y_lm  <- my_lm_model$pred$pred
y_knn <- my_knn_model$pred$pred

my_df <- data.frame(
  lm  = (y - y_lm)^2,
  knn = (y - y_knn)^2)

head(my_df)
#>           lm      knn
#> 1  18.913720 108.1600
#> 2 179.215044   0.6400
#> 3  41.034336 175.5625
#> 4 168.490212  49.0000
#> 5   5.085308   9.0000
#> 6  67.615888 112.8906

boxplot(my_df, ylab = "r^2")

t.test(x = my_df$lm, y = my_df$knn,
       conf.level = 0.95,
       paired = TRUE,
       alternative = "two.sided")

#> 	Paired t-test
#>
#> data:  my_df$lm and my_df$knn
#> t = -0.12838, df = 49, p-value = 0.8984
#> alternative hypothesis: true difference in means is not equal to 0
#> 95 percent confidence interval:
#>  -53.46930  47.04792
#> sample estimates:
#> mean of the differences
#>               -3.210688
