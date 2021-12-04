pdf(file = "04-r-ggplot-point.pdf", width = 6, height = 4)

library(tidyverse)

iris %>%
  ggplot(aes(x = Sepal.Length,
             y = Sepal.Width)) +
  geom_point()
