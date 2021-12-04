## 8.3 標準化

library(caret)
library(tidyverse)
my_url <- str_c("https://raw.githubusercontent.com/taroyabuki",
                "/fromzero/master/data/wine.csv")
my_data <- read_csv(my_url)

my_data %>%
  mutate_if(is.numeric, scale) %>% # 数値の列の標準化
  pivot_longer(-LPRICE2) %>%
  ggplot(aes(x = name, y = value)) +
  geom_boxplot() +
  stat_summary(fun = mean, geom = "point", size = 3) +
  xlab(NULL)

my_model <- train(
  form = LPRICE2 ~ .,
  data = my_data,
  method = "lm",
  preProcess = c("center", "scale"))

coef(my_model$finalModel) %>%
  as.data.frame
#>                      .
#> (Intercept) -1.4517652
#> WRAIN        0.1505557
#> DEGREES      0.4063194
#> HRAIN       -0.2820746
#> TIME_SV      0.1966549

my_test <- data.frame(
  WRAIN = 500, DEGREES = 17,
  HRAIN = 120, TIME_SV = 2)
my_model %>% predict(my_test)
#>         1
#> -1.498843
