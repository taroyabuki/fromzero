pdf(file = "09-r-rpart.pdf", width = 5.83, height = 4.13)

library(caret)
my_data <- iris
my_model <- train(form = Species ~ ., data = my_data, method = "rpart2")
rpart.plot::rpart.plot(my_model$finalModel, extra = 1)
