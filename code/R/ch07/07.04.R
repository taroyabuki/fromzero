## 7.4 当てはまりの良さの指標

### 7.4.1 RMSE

library(caret)
library(tidyverse)
my_data <- cars
my_model <- train(form = dist ~ speed, data = my_data, method = "lm")

y  <- my_data$dist
y_ <- my_model %>% predict(my_data)
my_data$y_ <- y_

my_data$residual <- y - y_
head(my_data)
#>   speed dist        y_  residual
#> 1     4    2 -1.849460  3.849460
#> 2     4   10 -1.849460 11.849460
#> 3     7    4  9.947766 -5.947766
#> 4     7   22  9.947766 12.052234
#> 5     8   16 13.880175  2.119825
#> 6     9   10 17.812584 -7.812584

my_data %>%
  ggplot(aes(x = speed, y = dist)) +
  geom_point() +
  geom_line(aes(x = speed, y = y_)) +
  geom_linerange(mapping = aes(ymin = y_, ymax = dist), linetype = "dotted")

RMSE(y_, y)
# あるいは
mean((my_data$residual^2))**0.5

#> [1] 15.06886

### 7.4.2 決定係数

R2(pred = y_, obs = y,
   form = "traditional")
#> [1] 0.6510794

R2(pred = y_, obs = y,
   form = "corr")
# あるいは
summary(my_model$finalModel)$r.squared
#> [1] 0.6510794

my_test <- my_data[1:3, ]
y  <- my_test$dist
y_ <- my_model %>% predict(my_test)

R2(pred = y_, obs = y,
   form = "traditional")
#> [1] -4.498191  # 決定係数1

R2(pred = y_, obs = y,
   form = "corr")
#> [1] 0.07692308 # 決定係数6

### 7.4.3 当てはまりの良さの指標の問題点

library(caret)
library(tidyverse)
my_data <- cars
my_idx <- c(2, 11, 27, 34, 39, 44)
my_sample <- my_data[my_idx, ]

options(warn = -1) # これ以降，警告を表示しない．
my_model <- train(form = dist ~ poly(speed, degree = 5, raw = TRUE),
                  data = my_sample,
                  method = "lm")
options(warn = 0)  # これ以降，警告を表示する．

y  <- my_sample$dist
y_ <- my_model %>% predict(my_sample)

RMSE(y_, y)
#> [1] 1.042275e-10 # RMSE

R2(pred = y_, obs = y,
   form = "traditional")
#> [1] 1 # 決定係数1

R2(pred = y_, obs = y,
   form = "corr")
#> [1] 1 # 決定係数6

f <- function(x) { my_model %>% predict(data.frame(speed = x)) }

my_data %>%
  ggplot(aes(x = speed, y = dist, color = "data")) +
  geom_point() +
  geom_point(data = my_sample, mapping = aes(color = "sample")) +
  stat_function(fun = f, mapping = aes(color = "model")) +
  coord_cartesian(ylim = c(0, 120))
