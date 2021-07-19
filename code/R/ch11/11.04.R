## 11.4 AutoML

### 11.4.1 H2Oの起動と停止

library(h2o)
library(keras)
library(tidyverse)

h2o.init()
h2o.no_progress()
# h2o.shutdown(prompt = FALSE) # 停止

### 11.4.2 H2Oのデータフレーム

my_url <- str_c("https://raw.githubusercontent.com/taroyabuki",
                "/fromzero/master/data/wine.csv")
my_data <- read_csv(my_url)
my_frame <- as.h2o(my_data) # 通常のデータフレームをH2OFrameに変換する．
# あるいは
my_frame <- h2o.importFile(my_url, header = TRUE) # データを読み込む．

my_frame
#>    LPRICE2 WRAIN DEGREES HRAIN ...
#> 1 -0.99868   600 17.1167   160 ...
#> 2 -0.45440   690 16.7333    80 ...
#> 3 -0.80796   502 17.1500   130 ...
#> 4 -1.50926   420 16.1333   110 ...
#> 5 -1.71655   582 16.4167   187 ...
#> 6 -0.41800   485 17.4833   187 ...
#>
#> [27 rows x 5 columns]

# 通常のデータフレームに戻す．
my_frame %>% as.data.frame %>% head
# 結果は割愛（見た目は同じ）

### 11.4.3 AutoMLによる回帰

my_model <- h2o.automl(
    y = "LPRICE2",
    training_frame = my_frame,
    max_runtime_secs = 60)

min(my_model@leaderboard$rmse)
#> [1] 0.2922861

tmp <- my_model %>%
  predict(my_frame) %>%
  as.data.frame
y_ <- tmp$predict
y  <- my_data$LPRICE2

plot(y, y_)

### 11.4.4 AutoMLによる分類

c(c(x_train, y_train), c(x_test, y_test)) %<-% dataset_mnist()
my_index <- sample(1:60000, 6000)
x_train <- x_train[my_index, , ]
y_train <- y_train[my_index]

tmp <- x_train %>%
  array_reshape(c(-1, 28 * 28)) %>%
  as.data.frame
tmp$y <- as.factor(y_train)
my_train <- as.h2o(tmp)

tmp <- x_test %>%
  array_reshape(c(-1, 28 * 28)) %>%
  as.data.frame
my_test <- as.h2o(tmp)

my_model <- h2o.automl(
    y = "y",
    training_frame = my_train,
    max_runtime_secs = 120)

min(my_model@leaderboard$
    mean_per_class_error)
#> [1] 0.0806190885648608

tmp <- my_model %>%
  predict(my_test) %>% as.data.frame
y_ <- tmp$predict

mean(y_ == y_test)
#> [1] 0.9306
