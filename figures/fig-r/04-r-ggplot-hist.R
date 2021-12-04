pdf(file = "04-r-ggplot-hist.pdf", width = 6, height = 4)

library(tidyverse)

x <- iris$Sepal.Length
tmp <- seq(min(x), max(x),
           length.out = 10)
iris %>%
  ggplot(aes(x = Sepal.Length)) +
  geom_histogram(breaks = tmp,
                 closed = "left")
