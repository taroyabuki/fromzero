pdf(file = "03-r-temp.pdf", width = 5.83, height = 4.13)

library(tidyverse)

my_wider <- data.frame(
  day = c(25, 26, 27),
  min = c(20, 21, 15),
  max = c(24, 27, 21))

my_longer <- my_wider %>%
  pivot_longer(-day)

my_longer %>%
  ggplot(aes(x = day, y = value,
             color = name)) +
  geom_point() +
  geom_line() +
  ylab("temperature") +
  scale_x_continuous(
    breaks = my_longer$day)
