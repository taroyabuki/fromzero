pdf(file = "11-r-mnist-lenet-miss.pdf", width = 5.83, height = 4.13)

library(keras)
library(tidyverse)
c(c(x_train, y_train), c(x_test, y_test)) %<-% dataset_mnist()

#my_index <- sample(1:60000, 6000)
#x_train <- x_train[my_index, , ]
#y_train <- y_train[my_index]

x_train <- x_train / 255
x_test  <- x_test  / 255

x_train2d <- x_train %>% array_reshape(c(-1, 28, 28, 1))
x_test2d  <- x_test  %>% array_reshape(c(-1, 28, 28, 1))

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

y_prob <- my_model %>% predict(x_test2d) # カテゴリに属する確率

my_result <- data.frame(
  y_prob = apply(y_prob, 1, max),           # 確率の最大値
  y_     = apply(y_prob, 1, which.max) - 1, # 予測カテゴリ
  y      = y_test,                          # 正解
  id     = seq_len(length(y_test))) %>%     # 番号
  filter(y_ != y) %>%                       # 予測がはずれたものを残す
  arrange(desc(y_prob))                     # 確率の大きい順に並び替える
head(my_result)

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
