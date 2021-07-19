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
