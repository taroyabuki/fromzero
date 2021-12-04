pdf(file = "10-r-rpart2.pdf", width = 6, height = 5.5)

library(caret)
library(tidyverse)

my_url <- str_c("https://raw.githubusercontent.com",
                "/taroyabuki/fromzero/master/data/titanic.csv")
my_data <- read_csv(my_url)

my_enc <- my_data %>% dummyVars(formula = Survived ~ Class)
my_data2 <- my_enc %>%
  predict(my_data) %>%
  as.data.frame %>%
  mutate(Survived = my_data$Survived)

my_model2 <- train(form = Survived ~ ., data = my_data2, method = "rpart2",
                   tuneGrid = data.frame(maxdepth = 2),
                   trControl = trainControl(method = "LOOCV"))
rpart.plot::rpart.plot(my_model2$finalModel, extra = 1)
