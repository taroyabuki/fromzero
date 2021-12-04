pdf(file = "07-r-polynomial.pdf", width = 6, height = 4.5)

library(caret)
library(tidyverse)
my_data <- cars
my_idx <- c(2, 11, 27, 34, 39, 44)
my_sample <- my_data[my_idx, ]

my_model <- train(form = dist ~ poly(speed, degree = 5, raw = TRUE),
                  data = my_sample,
                  method = "lm")

f <- function(x) { my_model %>% predict(data.frame(speed = x)) }

my_data %>%
  ggplot(aes(x = speed, y = dist, color = "data")) +
  geom_point() +
  geom_point(data = my_sample, mapping = aes(color = "sample")) +
  stat_function(fun = f, mapping = aes(color = "model")) +
  coord_cartesian(ylim = c(0, 120))
