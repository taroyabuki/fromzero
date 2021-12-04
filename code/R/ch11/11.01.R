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
