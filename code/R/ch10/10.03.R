## 10.3 タイタニック

library(caret)
library(PRROC)
library(tidyverse)

my_url <- str_c("https://raw.githubusercontent.com/taroyabuki",
                "/fromzero/master/data/titanic.csv")
my_data <- read_csv(my_url)

head(my_data)
#> # A tibble: 6 x 4
#>   Class Sex   Age   Survived
#>   <chr> <chr> <chr> <chr>
#> 1 1st   Male  Child Yes
#> 2 1st   Male  Child Yes
#> 3 1st   Male  Child Yes
#> 4 1st   Male  Child Yes
#> 5 1st   Male  Child Yes
#> 6 1st   Male  Adult No

### 10.3.1 質的入力変数の扱い方

### 10.3.2 決定木の訓練

my_model <- train(form = Survived ~ ., data = my_data, method = "rpart2",
                  tuneGrid = data.frame(maxdepth = 2),
                  trControl = trainControl(method = "LOOCV"))

### 10.3.3 決定木の描画

rpart.plot::rpart.plot(my_model$finalModel, extra = 1)

### 10.3.4 決定木の評価

my_model$results
#>   maxdepth  Accuracy     Kappa
#> 1        2 0.7832803 0.4096365

y <- my_data$Survived
tmp <- my_model %>% predict(newdata = my_data, type = "prob")
y_score <- tmp$Yes

my_roc <- roc.curve(scores.class0 = y_score[y == "Yes"],
                    scores.class1 = y_score[y == "No"],
                    curve = TRUE)
my_roc$auc
#> [1] 0.7114887

my_roc %>% plot(xlab = "False Positive Rate",
                ylab = "True Positive Rate",
                legend = FALSE)

### 10.3.5 補足：質的入力変数の扱い

X <- my_data %>% select(Class) # 質的入力変数
y <- my_data$Survived          # 出力変数

options(warn = -1) # これ以降，警告を表示しない．
my_model1 <- train(x = X, y = y, method = "rpart2",
                   tuneGrid = data.frame(maxdepth = 2),
                   trControl = trainControl(method = "LOOCV"))
options(warn = 0)  # これ以降，警告を表示する．

rpart.plot::rpart.plot(my_model1$finalModel, extra = 1)
my_model1$results
#>   maxdepth  Accuracy     Kappa
#> 1        2 0.7137665 0.2373133

my_data2 <- my_data %>%
  dummyVars(formula = Survived ~ Class) %>%
  predict(my_data) %>%
  as.data.frame %>%
  mutate(Survived = my_data$Survived)

my_model2 <- train(form = Survived ~ ., data = my_data2, method = "rpart2",
                   tuneGrid = data.frame(maxdepth = 2),
                   trControl = trainControl(method = "LOOCV"))
rpart.plot::rpart.plot(my_model2$finalModel, extra = 1)
my_model2$results
#>   maxdepth  Accuracy     Kappa
#> 1        2 0.7137665 0.2373133

my_model3 <- train(form = Survived ~ Class, data = my_data, method = "rpart2",
                   tuneGrid = data.frame(maxdepth = 2),
                   trControl = trainControl(method = "LOOCV"))
rpart.plot::rpart.plot(my_model3$finalModel, extra = 1)
my_model3$results
#>   maxdepth  Accuracy     Kappa
#> 1        2 0.6915039 0.2674485
