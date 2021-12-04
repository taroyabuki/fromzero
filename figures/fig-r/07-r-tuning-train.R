pdf(file = "07-r-tuning-train.pdf", width = 6, height = 4.5)

library(caret)
library(tidyverse)
my_data <- cars

my_loocv <- function(k) {
  my_model <- train(form = dist ~ speed, data = my_data, method = "knn",
                    tuneGrid = data.frame(k = k),
                    trControl = trainControl(method = "LOOCV"))
  y  <- my_data$dist
  y_ <- my_model %>% predict(my_data)
  list(k = k,
       training = RMSE(y_, y),             # RMSE（訓練）
       validation = my_model$results$RMSE) # RMSE（検証）
}

my_results <- 1:15 %>% map_dfr(my_loocv)

my_results %>%
  pivot_longer(-k) %>%
  ggplot(aes(x = k, y = value,
             color = name)) +
  geom_line() + geom_point() +
  xlab("#Neighbors") + ylab("RMSE") +
  theme(legend.position = c(1, 0),
        legend.justification = c(1, 0))
