pdf(file = "10-r-titanic-tree.pdf", width = 6, height = 5)

library(caret)
library(tidyverse)

my_url <- str_c("https://raw.githubusercontent.com",
                "/taroyabuki/fromzero/master/data/titanic.csv")
my_data <- read_csv(my_url)

my_model <- train(form = Survived ~ ., data = my_data, method = "rpart2",
                  tuneGrid = data.frame(maxdepth = 2),
                  trControl = trainControl(method = "none"))
rpart.plot::rpart.plot(my_model$finalModel, extra = 1)
