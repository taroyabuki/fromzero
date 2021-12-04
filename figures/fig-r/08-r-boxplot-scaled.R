pdf(file = "08-r-boxplot-scaled.pdf", width = 6, height = 4.5)

library(tidyverse)
my_url <- str_c("https://raw.githubusercontent.com/taroyabuki",
                "/fromzero/master/data/wine.csv")
my_data <- read_csv(my_url)

my_data %>%
  mutate_if(is.numeric, scale) %>% # 数値の列の標準化
  pivot_longer(-LPRICE2) %>%
  ggplot(aes(x = factor(name, levels = names(my_data[, -1])),
             y = value)) +
  geom_boxplot() +
  stat_summary(fun = mean, geom = "point", size = 3) +
  xlab(NULL)
