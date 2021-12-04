pdf(file = "08-r-enet-path.pdf", width = 6, height = 4.5)

library(tidyverse)
my_url <- str_c("https://raw.githubusercontent.com/taroyabuki",
                "/fromzero/master/data/wine.csv")
my_data <- read_csv(my_url)

library(ggfortify)
library(glmnetUtils)

my_data2 <- my_data %>%
  mutate_all(scale) # 標準化

B <- 0.1

glmnet(
  form = LPRICE2 ~ .,
  data = my_data2,
  alpha = B) %>%
  autoplot(xvar = "lambda") +
  xlab("log A ( = log lambda)") +
  theme(legend.position =
          c(0.15, 0.25))
