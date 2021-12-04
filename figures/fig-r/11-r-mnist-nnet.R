pdf(file = "11-r-mnist-nnet.pdf", width = 5.83, height = 4.13)

library(keras)

c(c(x_train, y_train), c(x_test, y_test)) %<-% dataset_mnist()
my_index <- sample(1:60000, 6000)
x_train <- x_train[my_index, , ]
y_train <- y_train[my_index]

my_model <- keras_model_sequential() %>%
  layer_flatten(input_shape = c(28, 28)) %>%
  layer_dense(units = 256, activation = "relu") %>%
  layer_dense(units = 10, activation = "softmax")

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

mean(y_ == y_test)

my_model %>% evaluate(x = x_test, y = y_test)
