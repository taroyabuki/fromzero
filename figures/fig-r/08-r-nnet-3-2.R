library(tidyverse)
my_url <- str_c("https://raw.githubusercontent.com/taroyabuki",
                "/fromzero/master/data/wine.csv")
my_data <- read_csv(my_url)

library(caret)
my_model <- train(form = LPRICE2 ~ .,
                  data = my_data,
                  method = "neuralnet",
                  preProcess = c("center", "scale"),
                  tuneGrid = data.frame(layer1 = 3,
                                        layer2 = 2,
                                        layer3 = 0),
                  trControl = trainControl(method = "repeatedcv",
                                           number = 5, repeats = 10))
plot(my_model$finalModel)
file.rename("Rplots.pdf", "08-r-nnet-3-2.pdf")
