## 11.3 MNIST：手書き数字の分類

### 11.3.1 データの形式

library(keras)
library(tidyverse)
c(c(x_train, y_train), c(x_test, y_test)) %<-% dataset_mnist()

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
#> 0.05227623 0.98390001

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
