pdf(file = "07-r-residual.pdf", width = 6, height = 4.5)

library(caret)
library(tidyverse)
my_data <- cars
my_model <- train(form = dist ~ speed, data = my_data, method = "lm")
y_ <- my_model %>% predict(my_data)
my_data$y_ <- y_

my_data %>%
  ggplot(aes(x = speed, y = dist)) +
  geom_point() +
  geom_line(aes(x = speed, y = y_)) +
  geom_linerange(mapping = aes(ymin = y_, ymax = dist), linetype = "dotted")
