pdf(file = "04-r-ggplot-box.pdf", width = 6, height = 4)

library(tidyverse)

iris %>%
  pivot_longer(-Species) %>%
  ggplot(aes(
    x = factor(name,
               levels = names(iris)),
    y = value)) +
  geom_boxplot() +
  xlab(NULL)
