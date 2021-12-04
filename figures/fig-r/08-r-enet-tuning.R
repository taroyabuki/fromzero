pdf(file = "08-r-enet-tuning.pdf", width = 6, height = 4.5)

library(caret)
library(tidyverse)
my_url <- str_c("https://raw.githubusercontent.com/taroyabuki",
                "/fromzero/master/data/wine.csv")
my_data <- read_csv(my_url)

As <- seq(0, 0.1, length.out = 21)
Bs <- seq(0, 0.1, length.out =  6)

my_model <- train(
  form = LPRICE2 ~ ., data = my_data, method = "glmnet", standardize = TRUE,
  trControl = trainControl(method = "LOOCV"),
  tuneGrid = expand.grid(lambda = As, alpha  = Bs))

tmp <- "B ( = alpha)"
ggplot(my_model) +
  theme(legend.position = c(0, 1), legend.justification = c(0, 1)) +
  xlab("A ( = lambda)") +
  guides(shape = guide_legend(tmp), color = guide_legend(tmp))
