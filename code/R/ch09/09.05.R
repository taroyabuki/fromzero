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
