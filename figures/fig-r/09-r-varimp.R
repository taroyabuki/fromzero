pdf(file = "09-r-varimp.pdf", width = 5.83, height = 4.13)

library(caret)
library(tidyverse)
my_data <- iris

my_model <- train(form = Species ~ ., data = my_data, method = "rf")
ggplot(varImp(my_model))
