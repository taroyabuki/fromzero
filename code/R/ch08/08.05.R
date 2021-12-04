## 8.5 変数選択

library(caret)
library(tidyverse)
my_url <- str_c("https://raw.githubusercontent.com/taroyabuki",
                "/fromzero/master/data/wine.csv")
my_data <- read_csv(my_url)
n <- nrow(my_data)
my_data2 <- my_data %>% mutate(v1 = 0:(n - 1) %% 2,
                               v2 = 0:(n - 1) %% 3)

my_model <- train(form = LPRICE2 ~ .,
                  data = my_data2,
                  method = "leapForward", # 変数増加法
                  trControl = trainControl(method = "LOOCV"),
                  tuneGrid = data.frame(nvmax = 1:6)) # 選択する変数の上限
summary(my_model$finalModel)$outmat
#>          WRAIN DEGREES HRAIN TIME_SV v1  v2
#> 1  ( 1 ) " "   "*"     " "   " "     " " " "
#> 2  ( 1 ) " "   "*"     "*"   " "     " " " "
#> 3  ( 1 ) " "   "*"     "*"   "*"     " " " "
#> 4  ( 1 ) "*"   "*"     "*"   "*"     " " " "
