pdf(file = "11-r-mnist-cnn.pdf", width = 5.83, height = 4.13)

library(keras)
c(c(x_train, y_train), c(x_test, y_test)) %<-% dataset_mnist()

my_index <- sample(1:60000, 6000)
x_train <- x_train[my_index, , ]
y_train <- y_train[my_index]

x_train <- x_train / 255
x_test  <- x_test  / 255

x_train2d <- x_train %>% array_reshape(c(-1, 28, 28, 1))
x_test2d  <- x_test  %>% array_reshape(c(-1, 28, 28, 1))

my_model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 32, kernel_size = 3,  # 畳み込み層
                activation = "relu",
                input_shape = c(28, 28, 1)) %>%
  layer_max_pooling_2d(pool_size = 2) %>%       # プーリング層
  layer_flatten() %>%
  layer_dense(units = 128, activation = "relu") %>%
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

my_model %>% evaluate(x = x_test2d, y = y_test)
