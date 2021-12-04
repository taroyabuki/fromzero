pdf(file = "12-r-airpassengers-lm.pdf", width = 5.83, height = 4.13)

my_data <- as.vector(AirPassengers)

n <- length(my_data) # データ数（144）
k <- 108             # 訓練データ数

library(tidyverse)
library(tsibble)

my_ds <- seq(
  from = yearmonth("1949/01"),
  to   = yearmonth("1960/12"),
  by   = 1)
my_label <- rep(
  c("train", "test"),
  c(k, n - k))
my_df <- tsibble(
  ds    = my_ds,
  x     = 0:(n - 1),
  y     = my_data,
  label = my_label,
  index = ds) # 日時の列の指定

my_train <- my_df[   1:k,  ]
my_test  <- my_df[- (1:k), ]

library(caret)
my_lm_model <- train(form = y ~ x, data = my_train, method = "lm")

y_ <- my_lm_model %>% predict(my_df)
tmp <- my_df %>%
  mutate(y = y_, label = "model")
my_plot <- my_df %>%
  ggplot(aes(x = ds,
             y = y,
             color = label)) +
  geom_line()
my_plot + geom_line(data = tmp)
