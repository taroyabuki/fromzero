pdf(file = "11-r-classification.pdf", width = 5.83, height = 4.13)

library(keras)
library(tidyverse)

my_data <- iris[sample(nrow(iris)), ]

X <- my_data %>%
  select(-Species) %>% scale
y <- as.integer(my_data$Species) - 1

my_model <- keras_model_sequential() %>%
  layer_dense(units = 3, activation = "relu", input_shape = c(4)) %>%
  layer_dense(units = 3, activation = "softmax")

my_model %>% compile(
  loss = "sparse_categorical_crossentropy",
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

tmp <- my_model %>% predict(X)
y_ <- apply(tmp, 1, which.max) - 1
mean(y_ == y)
