pdf(file = "09-r-rpart2.pdf", width = 6, height = 5.5)

library(caret)
my_data <- iris

my_model <- train(form = Species ~ ., data = my_data, method = "rpart2",
                  trControl = trainControl(method = "none"),
                  tuneGrid = data.frame(maxdepth = 3),
                  control = rpart::rpart.control(cp = 0.01,
                                                 minbucket = 5,
                                                 minsplit = 2))

rpart.plot::rpart.plot(
  my_model$finalModel, extra = 1)
