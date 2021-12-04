pdf(file = "07-r-knn.pdf", width = 6, height = 4.5)

library(caret)
library(tidyverse)
my_data <- cars
my_model <- train(form = dist ~ speed, # モデル式
                  data = my_data,      # データ
                  method = "knn",      # 手法
                  tuneGrid = data.frame(k = 5))

f <- function(x) { my_model %>% predict(data.frame(speed = x)) }

my_data %>%
  ggplot(aes(x = speed,
             y = dist,
             color = "data")) +
  geom_point() +
  stat_function(
    fun = f,
    mapping = aes(color = "model"))
