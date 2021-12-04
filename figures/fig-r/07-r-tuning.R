pdf(file = "07-r-tuning.pdf", width = 5.83, height = 4.13)

set.seed(0)

library(caret)
library(tidyverse)
my_data <- cars
my_model <- train(form = dist ~ speed, data = my_data, method = "knn",
                  tuneGrid = expand.grid(k = 1:15),
                  trControl = trainControl(method = "LOOCV"))
ggplot(my_model)
