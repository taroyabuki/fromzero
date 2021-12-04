pdf(file = "10-r-rpart1.pdf", width = 6, height = 5.5)

library(caret)
library(tidyverse)

my_url <- str_c("https://raw.githubusercontent.com",
                "/taroyabuki/fromzero/master/data/titanic.csv")
my_data <- read_csv(my_url)

X <- my_data %>% select(Class)
y <- my_data$Survived

options(warn = -1) # 警告を非表示にする．（tribbleに関する警告）
my_model1 <- train(x = X, y = y, method = "rpart2",
                   tuneGrid = data.frame(maxdepth = 2),
                   trControl = trainControl(method = "LOOCV"))
options(warn = 0)  # 警告を表示する．
rpart.plot::rpart.plot(my_model1$finalModel, extra = 1)
