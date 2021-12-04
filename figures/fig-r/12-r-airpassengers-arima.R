pdf(file = "12-r-airpassengers-arima.pdf", width = 5.83, height = 4.13)

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

library(fable)
my_arima_model <- my_train %>% model(ARIMA(y))

tmp <- my_arima_model %>% forecast(h = "3 years")

tmp %>% autoplot +
  geom_line(data = my_df,
            aes(x = ds,
                y = y,
                color = label))
