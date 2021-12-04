pdf(file = "04-r-pvalue1.pdf", width = 5.83, height = 4.13)

library(tidyverse)

t <- 4 / 10               # 当たる確率
n <- 15                   # くじを引いた回数
x <- 0:n                  # 当たった回数
my_pr  <- dbinom(x, n, t) # x回当たる確率
my_pr2 <- dbinom(2, n, t) # 2回当たる確率

my_data <- data.frame(x = x) %>%
  mutate(probability = my_pr) %>%
  mutate(color = my_pr <= my_pr2) # 当たる確率が，2回当たる確率以下

my_data %>% ggplot(aes(x = x, y = probability, color = color)) +
  geom_point(size = 3) +
  geom_linerange(aes(ymin = 0, ymax = probability), ) + # 垂直線
  geom_hline(yintercept = my_pr2) +                     # 水平線
  theme(legend.position = "none")
