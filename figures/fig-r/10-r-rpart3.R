pdf(file = "10-r-rpart3.pdf", width = 6, height = 5.5)

library(caret)
library(tidyverse)

my_url <- str_c("https://raw.githubusercontent.com",
                "/taroyabuki/fromzero/master/data/titanic.csv")
my_data <- read_csv(my_url)

my_model3 <- train(form = Survived ~ Class, data = my_data, method = "rpart2",
                   tuneGrid = data.frame(maxdepth = 2),
                   trControl = trainControl(method = "LOOCV"))
rpart.plot::rpart.plot(my_model3$finalModel, extra = 1)
