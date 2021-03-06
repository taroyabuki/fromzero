## 8.7 ニューラルネットワーク

### 8.7.1 ニューラルネットワークとは何か

curve(1 / (1 + exp(-x)), -6, 6)

### 8.7.2 ニューラルネットワークの訓練

library(caret)
library(tidyverse)
my_url <- str_c("https://raw.githubusercontent.com/taroyabuki",
                "/fromzero/master/data/wine.csv")
my_data <- read_csv(my_url)

my_model <- train(form = LPRICE2 ~ .,
                  data = my_data,
                  method = "neuralnet",              # ニューラルネットワーク
                  preProcess = c("center", "scale"), # 標準化
                  trControl = trainControl(method = "LOOCV"))
plot(my_model$finalModel) # 訓練済ネットワークの描画

my_model$results
#>   layer1 layer2 layer3      RMSE ...
#> 1      1      0      0 0.3504016 ...
#> 2      3      0      0 0.4380399 ...
#> 3      5      0      0 0.4325535 ...

### 8.7.3 ニューラルネットワークのチューニング

my_model <- train(
  form = LPRICE2 ~ .,
  data = my_data,
  method = "neuralnet",
  preProcess = c("center", "scale"),
  trControl = trainControl(method = "LOOCV"),
  tuneGrid = expand.grid(layer1 = 1:5,
                         layer2 = 0:2,
                         layer3 = 0))

my_model$results %>%
  filter(RMSE == min(RMSE))
#>   layer1 layer2 layer3      RMSE ...
#> 1      2      0      0 0.3165704 ...
