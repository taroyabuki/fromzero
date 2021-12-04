pdf(file = "07-r-boxplot.pdf", width = 6, height = 5.5)

library(caret)
my_data <- cars

my_lm_model <- train(form = dist ~ speed, data = my_data, method = "lm",
                     trControl = trainControl(method = "LOOCV"))

my_knn_model <- train(form = dist ~ speed, data = my_data, method = "knn",
                      tuneGrid = data.frame(k = 5),
                      trControl = trainControl(method = "LOOCV"))
y <- my_data$dist

my_df <- data.frame(
  lm  = (y - my_lm_model$pred$pred)^2,
  knn = (y - my_knn_model$pred$pred)^2)

boxplot(my_df, ylab = "r^2")
