## 9.1 アヤメのデータ

my_data <- iris
head(my_data)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa

psych::describe(my_data)
#>              vars   n mean   sd median trimmed  mad min max range ...
#> Sepal.Length    1 150 5.84 0.83   5.80    5.81 1.04 4.3 7.9   3.6 ...
#> Sepal.Width     2 150 3.06 0.44   3.00    3.04 0.44 2.0 4.4   2.4 ...
#> Petal.Length    3 150 3.76 1.77   4.35    3.76 1.85 1.0 6.9   5.9 ...
#> Petal.Width     4 150 1.20 0.76   1.30    1.18 1.04 0.1 2.5   2.4 ...
#> Species*        5 150 2.00 0.82   2.00    2.00 1.48 1.0 3.0   2.0 ...

## 9.2 木による分類

### 9.2.1 分類木の作成と利用

library(caret)
library(tidyverse)
my_data <- iris
my_model <- train(form = Species ~ ., data = my_data, method = "rpart")

rpart.plot::rpart.plot(my_model$finalModel, extra = 1)

my_test <- tribble(
~Sepal.Length, ~Sepal.Width, ~Petal.Length, ~Petal.Width,
          5.0,          3.5,           1.5,          0.5,
          6.5,          3.0,           5.0,          2.0)

my_model %>% predict(my_test)
#> [1] setosa    virginica
#> Levels: setosa versicolor virginica

my_model %>% predict(my_test,
                     type = "prob")
#>   setosa versicolor virginica
#> 1      1 0.00000000 0.0000000
#> 2      0 0.02173913 0.9782609

## 9.3 正解率

### 9.3.1 混同行列

library(caret)
library(tidyverse)
my_data <- iris
my_model <- train(form = Species ~ ., data = my_data, method = "rpart2")

y  <- my_data$Species
y_ <- my_model %>% predict(my_data)
confusionMatrix(data = y_, reference = y)
#> Confusion Matrix and Statistics
#>
#>             Reference
#> Prediction   setosa versicolor virginica
#>   setosa         50          0         0
#>   versicolor      0         49         1
#>   virginica       0          5        45
# 以下は割愛

### 9.3.2 正解率（訓練）

y  <- my_data$Species
y_ <- my_model %>% predict(my_data)
mean(y_ == y)
#> [1] 0.96

### 9.3.3 正解率（検証）

my_model <- train(form = Species ~ ., data = my_data, method = "rpart2",
                  trControl = trainControl(method = "LOOCV"))
my_model$results
#>   maxdepth  Accuracy Kappa
#> 1        1 0.3333333  0.00
#> 2        2 0.9533333  0.93

### 9.3.4 パラメータチューニング

my_model <- train(form = Species ~ ., data = my_data, method = "rpart2",
                  tuneGrid = data.frame(maxdepth = 1:10),
                  trControl = trainControl(method = "LOOCV"))
my_model$results %>% filter(Accuracy == max(Accuracy))
#>   maxdepth  Accuracy Kappa
#> 1        2 0.9533333  0.93

### 9.3.5 補足：木の複雑さの制限

# パラメータを与えると正解率（LOOCV）を返す関数
my_loocv <- function(maxdepth, minbucket, minsplit) {
  my_model <- train(form = Species ~ ., data = my_data, method = "rpart2",
                    trControl = trainControl(method = "LOOCV"),
                    tuneGrid = data.frame(maxdepth = maxdepth),
                    control = rpart::rpart.control(cp = 0.01,
                                                   minbucket = minbucket,
                                                   minsplit = minsplit))
  list(maxdepth = maxdepth,
       minbucket = minbucket,
       minsplit = minsplit,
       Accuracy = my_model$results$Accuracy)
}

my_params <- expand.grid(
  maxdepth = 2:5,
  minbucket = 1:7,
  minsplit = c(2, 20))

library(furrr)
plan(multisession) # 並列処理の準備
my_results <- my_params %>% future_pmap_dfr(my_loocv, # 実行
  .options = furrr_options(seed = TRUE))

my_results %>% filter(Accuracy == max(Accuracy)) # 正解率（検証）の最大値
#>   maxdepth minbucket minsplit Accuracy
#>      <int>     <int>    <dbl>    <dbl>
#> 1        3         5        2    0.973
#> 2        4         5        2    0.973
#> 3        5         5        2    0.973
#> 4        3         5       20    0.973
#> 5        4         5       20    0.973
#> 6        5         5       20    0.973

my_model <- train(form = Species ~ ., data = my_data, method = "rpart2",
                  trControl = trainControl(method = "none"),
                  tuneGrid = data.frame(maxdepth = 3),
                  control = rpart::rpart.control(cp = 0.01,
                                                 minbucket = 5,
                                                 minsplit = 2))

rpart.plot::rpart.plot(
  my_model$finalModel, extra = 1)

## 9.4 複数の木を使う方法

### 9.4.1 ランダムフォレスト

library(caret)
library(tidyverse)
my_data <- iris

my_model <- train(form = Species ~ ., data = my_data, method = "rf",
                  tuneGrid = data.frame(mtry = 2:4), # 省略可
                  trControl = trainControl(method = "LOOCV"))
my_model$results
#>   mtry Accuracy Kappa
#> 1    2     0.96  0.94
#> 2    3     0.96  0.94
#> 3    4     0.96  0.94

### 9.4.2 ブースティング

my_model <- train(
  form = Species ~ ., data = my_data, method = "xgbTree",
  tuneGrid = expand.grid(
    nrounds          = c(50, 100, 150),
    max_depth        = c(1, 2, 3),
    eta              = c(0.3, 0.4),
    gamma            = 0,
    colsample_bytree = c(0.6, 0.8),
    min_child_weight = 1,
    subsample        = c(0.5, 0.75, 1)),
  trControl = trainControl(method = "cv", number = 5)) # 5分割交差検証
my_model$results %>% filter(Accuracy == max(Accuracy)) %>% head(5) %>% t
#>                            1           2           3           4           5
#> eta               0.30000000  0.30000000  0.30000000  0.40000000  0.30000000
#> max_depth         1.00000000  1.00000000  1.00000000  1.00000000  3.00000000
#> gamma             0.00000000  0.00000000  0.00000000  0.00000000  0.00000000
#> colsample_bytree  0.60000000  0.60000000  0.80000000  0.60000000  0.80000000
#> min_child_weight  1.00000000  1.00000000  1.00000000  1.00000000  1.00000000
#> subsample         0.50000000  0.75000000  0.75000000  0.50000000  0.50000000
#> nrounds          50.00000000 50.00000000 50.00000000 50.00000000 50.00000000
#> Accuracy          0.96000000  0.96000000  0.96000000  0.96000000  0.96000000
#> Kappa             0.94000000  0.94000000  0.94000000  0.94000000  0.94000000
#> AccuracySD        0.02788867  0.02788867  0.02788867  0.01490712  0.01490712
#> KappaSD           0.04183300  0.04183300  0.04183300  0.02236068  0.02236068

### 9.4.3 入力変数の重要度

my_model <- train(form = Species ~ ., data = my_data, method = "rf")
ggplot(varImp(my_model))

## 9.5 欠損のあるデータでの学習

### 9.5.1 欠損のあるデータの準備

library(caret)
library(tidyverse)
my_data <- iris

n <- nrow(my_data)
my_data$Petal.Length[0:(n - 1) %% 10 == 0] <- NA
my_data$Petal.Width[ 0:(n - 1) %% 10 == 1] <- NA

psych::describe(my_data) # nの値が135の変数に，150 - 135 = 15個の欠損がある．
#>              vars   n mean   sd median trimmed  mad min max range ...
#> Sepal.Length    1 150 5.84 0.83    5.8    5.81 1.04 4.3 7.9   3.6 ...
#> Sepal.Width     2 150 3.06 0.44    3.0    3.04 0.44 2.0 4.4   2.4 ...
#> Petal.Length    3 135 3.75 1.76    4.3    3.75 1.78 1.0 6.9   5.9 ...
#> Petal.Width     4 135 1.20 0.77    1.3    1.18 1.04 0.1 2.5   2.4 ...
#> Species*        5 150 2.00 0.82    2.0    2.00 1.48 1.0 3.0   2.0 ...

### 9.5.2 方針1：欠損を埋めて学習する．

my_model <- train(
  form = Species ~ ., data = my_data, method = "rpart2",
  na.action = na.pass,         # 欠損があっても学習を止めない．
  preProcess = "medianImpute", # 欠損を中央値で埋める．
  trControl = trainControl(method = "LOOCV"),
  tuneGrid = data.frame(maxdepth = 20),          # 木の高さの上限
  control = rpart::rpart.control(minsplit = 2,   # 分岐の条件
                                 minbucket = 1)) # 終端ノードの条件
max(my_model$results$Accuracy)
#> [1] 0.9266667

### 9.5.3 方針2：欠損があっても使える手法で学習する．

my_model <- train(form = Species ~ ., data = my_data, method = "xgbTree",
                  na.action = na.pass,
                  trControl = trainControl(method = "cv", number = 5))
max(my_model$results$Accuracy)
#> [1] 0.966666666666667

## 9.6 他の分類手法

### 9.6.1 K最近傍法

library(caret)
library(tidyverse)
my_data <- iris

my_model <- train(form = Species ~ ., data = my_data, method = "knn",
                  trControl = trainControl(method = "LOOCV"))
my_model$results %>% filter(Accuracy == max(Accuracy))
#>   k  Accuracy Kappa
#> 1 9 0.9733333  0.96

### 9.6.2 ニューラルネットワーク

library(caret)
library(tidyverse)
my_data <- iris

my_model <- train(form = Species ~ ., data = my_data, method = "nnet",
                  preProcess = c("center", "scale"), # 標準化
                  trControl = trainControl(method = "LOOCV"),
                  trace = FALSE) # 途中経過を表示しない
my_model$results %>% filter(Accuracy == max(Accuracy))
#>   size decay  Accuracy Kappa
#> 1    3   0.1 0.9733333  0.96
#> 2    5   0.1 0.9733333  0.96

