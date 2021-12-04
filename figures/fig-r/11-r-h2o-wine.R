pdf(file = "11-r-h2o-wine.pdf", width = 6, height = 5.5)

library(h2o)
library(tidyverse)

h2o.init()
h2o.no_progress()

my_url <- str_c("https://raw.githubusercontent.com",
                "/taroyabuki/fromzero/master/data/wine.csv")
my_data <- read_csv(my_url)
my_frame <- as.h2o(my_data)

my_model <- h2o.automl(
    y = "LPRICE2",             # 出力変数名
    training_frame = my_frame, # H2OFrame
    max_runtime_secs = 60)     # 訓練時間（秒）

min(my_model@leaderboard$rmse)

tmp <- my_model %>% predict(my_frame) %>%
  as.data.frame
y_ <- tmp$predict
y  <- my_data$LPRICE2

plot(y, y_)
