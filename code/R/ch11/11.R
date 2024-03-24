## 11.1 Kerasによる回帰

library(keras)
library(tidyverse)
my_url <- str_c("https://raw.githubusercontent.com/taroyabuki",
                "/fromzero/master/data/wine.csv")
tmp <- read_csv(my_url)

my_data <- tmp[sample(nrow(tmp)), ]

X <- my_data %>%
  select(-LPRICE2) %>% scale
y <- my_data$LPRICE2

curve(activation_relu(x), -3, 3)

my_model <- keras_model_sequential() %>%
  layer_dense(units = 3, activation = "relu", input_shape = c(4)) %>%
  layer_dense(units = 1)

summary(my_model) # ネットワークの概要
# 割愛（Pythonの結果を参照）

my_model %>% compile(
  loss = "mse",
  optimizer = "rmsprop")

my_cb <- callback_early_stopping(
  patience = 20,
  restore_best_weights = TRUE)

my_history <- my_model %>% fit(
    x = X,
    y = y,
    validation_split = 0.25,
    batch_size = 10,
    epochs = 500,
    callbacks = list(my_cb),
    verbose = 0)

plot(my_history)

my_history
#> Final epoch (plot to see history):
#>     loss: 0.06124
#> val_loss: 0.1132

y_ <- my_model %>% predict(X)
mean((y_ - y)^2)**0.5
#> [1] 0.2724372

## 11.2 Kerasによる分類

library(keras)
library(tidyverse)
my_data <- iris[sample(nrow(iris)), ]

X <- my_data %>%
  select(-Species) %>% scale
y <- as.integer(my_data$Species) - 1

my_model <- keras_model_sequential() %>%
  layer_dense(units = 3, activation = "relu", input_shape = c(4)) %>%
  layer_dense(units = 3, activation = "softmax")

my_model %>% compile(loss = "sparse_categorical_crossentropy",
                     optimizer = "rmsprop",
                     metrics = c("accuracy"))

my_cb <- callback_early_stopping(
  patience = 20,
  restore_best_weights = TRUE)

my_history <- my_model %>%
  fit(x = X,
    y = y,
    validation_split = 0.25,
    batch_size = 10,
    epochs = 500,
    callbacks = list(my_cb),
    verbose = 0)

plot(my_history)

my_history
#> Final epoch (plot to see history):
#>         loss: 0.06206
#>     accuracy: 0.9732
#>     val_loss: 0.1269
#> val_accuracy: 0.9211

tmp <- my_model %>% predict(X)
y_ <- apply(tmp, 1, which.max) - 1
mean(y_ == y)
#> [1] 0.9666667

### 11.2.1 交差エントロピー

-mean(log(c(0.8, 0.7, 0.3, 0.8)))
#> 0.5017337

-mean(log(c(0.7, 0.6, 0.2, 0.7)))
#> 0.7084034

y <- c(2, 1, 0, 1)
y_1 <- list(c(0.1, 0.1, 0.8),
            c(0.1, 0.7, 0.2),
            c(0.3, 0.4, 0.3),
            c(0.1, 0.8, 0.1))
y_2 <- list(c(0.1, 0.2, 0.7),
            c(0.2, 0.6, 0.2),
            c(0.2, 0.5, 0.3),
            c(0.2, 0.7, 0.1))

c(mean(as.array(loss_sparse_categorical_crossentropy(y_true = y, y_pred = y_1))),
  mean(as.array(loss_sparse_categorical_crossentropy(y_true = y, y_pred = y_2))))
#> [1] 0.5017337 0.7084033

## 11.3 MNIST：手書き数字の分類

### 11.3.1 データの形式

library(keras)
library(tidyverse)
keras::`%<-%`(c(c(x_train, y_train), c(x_test, y_test)), dataset_mnist())

dim(x_train)
#> [1] 60000    28    28

x_train[5, , ]

plot(as.raster(x = x_train[5, , ],
               max = max(x_train)))

head(y_train)
#> [1] 5 0 4 1 9 2

c(min(x_train), max(x_train))
#> [1]   0 255

x_train <- x_train / 255
x_test  <- x_test  / 255

my_index <- sample(1:60000, 6000)
x_train <- x_train[my_index, , ]
y_train <- y_train[my_index]

### 11.3.2 多層パーセプトロン

my_model <- keras_model_sequential() %>%
  layer_flatten(input_shape = c(28, 28)) %>%
  layer_dense(units = 256, activation = "relu") %>%
  layer_dense(units = 10, activation = "softmax")
summary(my_model)
# 割愛（Pythonの結果を参照）

my_model %>% compile(loss = "sparse_categorical_crossentropy",
                     optimizer = "rmsprop",
                     metrics = c("accuracy"))

my_cb <- callback_early_stopping(patience = 5,
                                 restore_best_weights = TRUE)

my_history <- my_model %>%
  fit(x = x_train,
      y = y_train,
      validation_split = 0.2,
      batch_size = 128,
      epochs = 20,
      callbacks = list(my_cb),
      verbose = 0)

plot(my_history)

tmp <- my_model %>% predict(x_test)
y_ <- apply(tmp, 1, which.max) - 1
table(y_, y_test)

#>    y_test
#> y_     0    1    2    3    4    5    6    7    8    9
#>   0  962    0    8    2    0    6   11    0    8   11
#>   1    0 1110    1    0    3    1    3    8    2    4
#>   2    0    5  959   13    4    4    2   16    6    1
#>   3    1    1   22  958    1   27    0    7   33   13
#>   4    2    0    6    1  905    8    6    6    3   14
#>   5    5    2    0   12    1  809    9    1   15    4
#>   6    6    3    8    0    8   11  922    0    5    1
#>   7    1    1    7    7    1    2    0  963    4    8
#>   8    2   13   19   13    4   16    5    0  890    5
#>   9    1    0    2    4   55    8    0   27    8  948

mean(y_ == y_test)
#> [1] 0.9426000

my_model %>%
  evaluate(x = x_test, y = y_test)
#>      loss  accuracy
#> 0.2071411 0.9426000

### 11.3.3 畳み込みニューラルネットワーク（CNN）

x_train2d <- x_train %>% array_reshape(c(-1, 28, 28, 1))
x_test2d  <- x_test  %>% array_reshape(c(-1, 28, 28, 1))

#### 11.3.3.1 単純なCNN

my_model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 32, kernel_size = 3,  # 畳み込み層
                activation = "relu",
                input_shape = c(28, 28, 1)) %>%
  layer_max_pooling_2d(pool_size = 2) %>%       # プーリング層
  layer_flatten() %>%
  layer_dense(units = 128, activation = "relu") %>%
  layer_dense(units = 10, activation = "softmax")

summary(my_model)
# 割愛（Python の結果を参照）

my_model %>% compile(loss = "sparse_categorical_crossentropy",
                     optimizer = "rmsprop",
                     metrics = c("accuracy"))

my_cb <- callback_early_stopping(patience = 5,
                                 restore_best_weights = TRUE)

my_history <- my_model %>%
  fit(x = x_train2d,
      y = y_train,
      validation_split = 0.2,
      batch_size = 128,
      epochs = 20,
      callbacks = list(my_cb),
      verbose = 0)

plot(my_history)

my_model %>%
  evaluate(x = x_test2d, y = y_test)
#>      loss  accuracy
#> 0.1392894 0.9607000

#### 11.3.3.2 LeNet

my_model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 20, kernel_size = 5, activation = "relu",
                input_shape = c(28, 28, 1)) %>%
  layer_max_pooling_2d(pool_size = 2, strides = 2) %>%
  layer_conv_2d(filters = 50, kernel_size = 5, activation = "relu") %>%
  layer_max_pooling_2d(pool_size = 2, strides = 2) %>%
  layer_dropout(rate = 0.25) %>%
  layer_flatten() %>%
  layer_dense(units = 500, activation = "relu") %>%
  layer_dropout(rate = 0.5) %>%
  layer_dense(units = 10, activation = "softmax")

my_model %>% compile(
  loss = "sparse_categorical_crossentropy",
  optimizer = "rmsprop",
  metrics = c("accuracy"))

my_cb <- callback_early_stopping(patience = 5,
                                 restore_best_weights = TRUE)

my_history <- my_model %>%
  fit(x = x_train2d,
      y = y_train,
      validation_split = 0.2,
      batch_size = 128,
      epochs = 20,
      callbacks = list(my_cb),
      verbose = 0)

plot(my_history)

my_model %>%
  evaluate(x = x_test2d, y = y_test)
#>      loss  accuracy
#> 0.07309694 0.98060000

#### 11.3.3.3 補足：LeNetが自信満々で間違う例

y_prob <- my_model %>% predict(x_test2d) # カテゴリに属する確率

my_result <- data.frame(
  y_prob = apply(y_prob, 1, max),           # 確率の最大値
  y_     = apply(y_prob, 1, which.max) - 1, # 予測カテゴリ
  y      = y_test,                          # 正解
  id     = seq_len(length(y_test))) %>%     # 番号
  filter(y_ != y) %>%                       # 予測がはずれたものを残す
  arrange(desc(y_prob))                     # 確率の大きい順に並び替える

head(my_result)
#>      y_prob y_ y   id
#> 1 0.9998116  9 4 2131
#> 2 0.9988768  6 5 9730
#> 3 0.9986107  3 5 2598
#> 4 0.9971705  3 5 2036
#> 5 0.9888211  1 6 2655
#> 6 0.9857675  0 6 2119

tmp <- my_result[1:5, ]$id
my_labels <- sprintf("%s (%s)",
  my_result[1:5, ]$y, tmp)
my_fig <- expand.grid(
  label = my_labels,
  y = 28:1,
  x = 1:28)
my_fig$z <- as.vector(
  x_test[tmp, , ])

my_fig %>% ggplot(
  aes(x = x, y = y, fill = z)) +
  geom_raster() +
  coord_fixed() +
  theme_void() +
  theme(legend.position = "none") +
  facet_grid(. ~ label)

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

keras::`%<-%`(c(c(x_train, y_train), c(x_test, y_test)), dataset_mnist())
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

