## 12.1 日時と日時の列

### 12.1.1 日時

as.POSIXct("2021-01-01")
#> [1] "2021-01-01 JST"

### 12.1.2 等間隔の日時

library(tsibble)

seq(from = 2021, to = 2023, by = 1)
#> [1] 2021 2022 2023

seq(from = yearmonth("202101"), to = yearmonth("202103"), by = 2)
#> <yearmonth[2]>
#> [1] "2021 1" "2021 3"

seq(from = as.POSIXct("2021-01-01"), to = as.POSIXct("2021-01-03"), by = "1 day")
#> [1] "2021-01-01 JST" "2021-01-02 JST" "2021-01-03 JST"

seq(from = as.POSIXct("2021-01-01 00:00:00"),
    to   = as.POSIXct("2021-01-01 03:00:00"), by = "2 hour")
#> [1] "2021-01-01 00:00:00 JST" "2021-01-01 02:00:00 JST"

## 12.2 時系列データの予測

### 12.2.1 データの準備

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

head(my_df)
#> # A tsibble: 6 x 4 [1M]
#>       ds     x     y label
#>    <mth> <int> <dbl> <chr>
#> 1 1949 1     0   112 train
#> 2 1949 2     1   118 train
#> 3 1949 3     2   132 train
#> 4 1949 4     3   129 train
#> 5 1949 5     4   121 train
#> 6 1949 6     5   135 train

my_train <- my_df[  1:k , ]
my_test  <- my_df[-(1:k), ]
y <- my_test$y

my_plot <- my_df %>%
  ggplot(aes(x = ds,
             y = y,
             color = label)) +
  geom_line()
my_plot

### 12.2.2 線形回帰分析による時系列予測

library(caret)
my_lm_model <- train(form = y ~ x, data = my_train, method = "lm")
y_ <- my_lm_model %>% predict(my_test)
caret::RMSE(y, y_) # RMSE（テスト）
#> [1] 70.63707

y_ <- my_lm_model %>% predict(my_df)
tmp <- my_df %>%
  mutate(y = y_, label = "model")
my_plot + geom_line(data = tmp)

### 12.2.3 SARIMAによる時系列予測

#### 12.2.3.1 モデルの構築

library(fable)
my_arima_model <- my_train %>% model(ARIMA(y))
my_arima_model
#> # A mable: 1 x 1
#>                  `ARIMA(y)`
#>                     <model>
#> 1 <ARIMA(1,1,0)(0,1,0)[12]>

#### 12.2.3.2 予測

tmp <- my_arima_model %>% forecast(h = "3 years")
head(tmp)
#> # A fable: 6 x 4 [1M]
#> # Key:     .model [1]
#> .model       ds           y .mean
#> <chr>     <mth>      <dist> <dbl>
#> 1 ARIMA(y) 1958 1  N(346, 94)  346.
#> 2 ARIMA(y) 1958 2 N(332, 148)  332.
#> 3 ARIMA(y) 1958 3 N(387, 210)  387.
#> 4 ARIMA(y) 1958 4 N(379, 271)  379.
#> 5 ARIMA(y) 1958 5 N(386, 332)  386.
#> 6 ARIMA(y) 1958 6 N(453, 393)  453.

y_ <- tmp$.mean
caret::RMSE(y_, y)
#> [1] 22.13223

# 予測結果のみでよい場合
#tmp %>% autoplot

tmp %>% autoplot +
  geom_line(data = my_df,
            aes(x = ds,
                y = y,
                color = label))

### 12.2.4 Prophetによる時系列予測

library(prophet)
my_prophet_model <- my_train %>%
  prophet(seasonality.mode = "multiplicative")

tmp <- my_prophet_model %>% predict(my_test)
head(tmp[, c("ds", "yhat", "yhat_lower", "yhat_upper")])
#> # A tibble: 6 x 4
#>   ds                   yhat yhat_lower yhat_upper
#>   <dttm>              <dbl>      <dbl>      <dbl>
#> 1 1958-01-01 00:00:00  359.       350.       368.
#> 2 1958-02-01 00:00:00  350.       342.       360.
#> 3 1958-03-01 00:00:00  407.       398.       416.
#> 4 1958-04-01 00:00:00  398.       389.       407.
#> 5 1958-05-01 00:00:00  402.       393.       411.
#> 6 1958-06-01 00:00:00  459.       450.       469.

y_ <- tmp$yhat
caret::RMSE(y_, y)
#> [1] 33.68719

# my_prophet_model %>% plot(tmp) # 予測結果のみでよい場合

my_prophet_model %>% plot(tmp) +
  geom_line(data = my_train, aes(x = as.POSIXct(ds))) +
  geom_line(data = my_test,  aes(x = as.POSIXct(ds)), color = "red")

