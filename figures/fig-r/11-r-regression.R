pdf(file = "11-r-regression.pdf", width = 5.83, height = 4.13)

library(keras)
library(tidyverse)

my_url <- str_c("https://raw.githubusercontent.com",
                "/taroyabuki/fromzero/master/data/wine.csv")
tmp <- read_csv(my_url)

my_data <- tmp[sample(nrow(tmp)), ]

X <- my_data %>%
  select(-LPRICE2) %>% scale
y <- my_data$LPRICE2

my_model <- keras_model_sequential() %>%
  layer_dense(units = 3, activation = "relu", input_shape = c(4)) %>%
  layer_dense(units = 1)

my_model %>% compile(
    loss = "mse",
    optimizer = "rmsprop")

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

y_ <- my_model %>% predict(X)
mean((y_ - y)^2)**0.5
