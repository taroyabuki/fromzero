pdf(file = "confidence_band_r.pdf", width = 6, height = 4.5)

library(boot)
library(tidyverse)

data <- read_csv("1+3x+N(0,2x).csv")
x <- data$x
y <- data$y
n <- nrow(data)

alpha <- 0.99
data %>% ggplot(aes(x = x, y = y)) +
  geom_point() +
  stat_smooth(formula = y ~ x, method = "lm", level = alpha)
