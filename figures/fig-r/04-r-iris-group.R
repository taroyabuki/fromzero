pdf(file = "04-r-iris-group.pdf", width = 6, height = 5)

library(tidyverse)
my_group <- iris %>% group_by(Species)

my_df <- my_group %>%
  summarize(across(everything(), mean)) %>% # 各列の平均
  pivot_longer(-Species)

# 標準誤差を求める関数
f <- function(x) { sd(x) / length(x)**0.5 }

tmp <- my_group %>%
  summarize(across(everything(), f)) %>% # 各列の標準誤差
  pivot_longer(-Species)

my_df$se <- tmp$value
my_df %>%
  ggplot(aes(x = Species, y = value, fill = name)) +
  geom_col(position = "dodge") +
  geom_errorbar(aes(ymin = value - se, ymax = value + se), position = "dodge")
