pdf(file = "10-r-titanic-roc.pdf", width = 6, height = 5)

library(caret)
library(PRROC)
library(tidyverse)

my_url <- str_c("https://raw.githubusercontent.com",
                "/taroyabuki/fromzero/master/data/titanic.csv")
my_data <- read_csv(my_url)

my_model <- train(form = Survived ~ ., data = my_data, method = "rpart2",
                  tuneGrid = data.frame(maxdepth = 2),
                  trControl = trainControl(method = "none"))

y <- my_data$Survived
tmp <- my_model %>% predict(newdata = my_data, type = "prob")
y_score <- tmp$Yes

my_roc <- roc.curve(scores.class0 = y_score[y == "Yes"],
                    scores.class1 = y_score[y == "No"],
                    curve = TRUE)
my_roc %>% plot(xlab = "False Positive Rate",
                ylab = "True Positive Rate",
                legend = FALSE)
