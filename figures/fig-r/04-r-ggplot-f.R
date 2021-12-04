pdf(file = "04-r-ggplot-f.pdf", width = 6, height = 4)

library(tidyverse)

f <- function(x) { x^3 - x }
data.frame(x = c(-2, 2)) %>%
  ggplot(aes(x = x)) +
  stat_function(fun = f)
