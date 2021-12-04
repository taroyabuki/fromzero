pdf(file = "07-r-plot.pdf", width = 6, height = 4.5)

library(tidyverse)
my_data <- cars

my_data %>%
  ggplot(aes(x = speed, y = dist)) +
  geom_point()
