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
