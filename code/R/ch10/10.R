## 10.1 2値分類の性能指標

### 10.1.1 陽性と陰性

y       <- c(  0,   1,   1,   0,   1,   0,    1,   0,   0,   1)
y_score <- c(0.7, 0.8, 0.3, 0.4, 0.9, 0.6, 0.99, 0.1, 0.2, 0.5)

y_ <- ifelse(0.5 <= y_score, 1, 0)
y_
#> [1] 1 1 0 0 1 1 1 0 0 1

library(caret)
confusionMatrix(data      = as.factor(y_), # 予測
                reference = as.factor(y),  # 正解
                positive = "1",            # 「1」を陽性とする．
                mode = "everything")       # 全ての指標を求める．
#> Confusion Matrix and Statistics
#>
#>           Reference
#> Prediction 0 1
#>          0 3 1
#>          1 2 4
#>
#>                Accuracy : 0.7
#>                  95% CI : (0.3475, 0.9333)
#>     No Information Rate : 0.5
#>     P-Value [Acc > NIR] : 0.1719
#>
#>                   Kappa : 0.4
#>
#>  Mcnemar's Test P-Value : 1.0000
#>
#>             Sensitivity : 0.8000
#>             Specificity : 0.6000
#>          Pos Pred Value : 0.6667
#>          Neg Pred Value : 0.7500
#>               Precision : 0.6667
#>                  Recall : 0.8000
#>                      F1 : 0.7273
#>              Prevalence : 0.5000
#>          Detection Rate : 0.4000
#>    Detection Prevalence : 0.6000
#>       Balanced Accuracy : 0.7000
#>
#>        'Positive' Class : 1

## 10.2 トレードオフ

### 10.2.1 偽陽性率と真陽性率のトレードオフ（ROC曲線）

library(PRROC)
library(tidyverse)

y       <- c(  0,   1,   1,   0,   1,   0,    1,   0,   0,   1)
y_score <- c(0.7, 0.8, 0.3, 0.4, 0.9, 0.6, 0.99, 0.1, 0.2, 0.5)
y_      <- ifelse(0.5 <= y_score, 1, 0)

c(sum((y == 0) & (y_ == 1)) / sum(y == 0), # FPR
  sum((y == 1) & (y_ == 1)) / sum(y == 1)) # TPR
#> [1] 0.4 0.8

my_roc <- roc.curve(scores.class0 = y_score[y == 1], # 答えが1のもののスコア
                    scores.class1 = y_score[y == 0], # 答えが0のもののスコア
                    curve = TRUE)
my_roc %>% plot(xlab = "False Positive Rate",
                ylab = "True Positive Rate",
                legend = FALSE)

my_roc$auc
#> [1] 0.8

### 10.2.2 再現率と精度のトレードオフ（PR曲線）

c(sum((y == 1) & (y_ == 1)) / sum(y  == 1), # Recall == TPR
  sum((y == 1) & (y_ == 1)) / sum(y_ == 1)) # Precision
#> [1] 0.8000000 0.6666667

my_pr <- pr.curve(scores.class0 = y_score[y == 1],
                  scores.class1 = y_score[y == 0],
                  curve = TRUE)
my_pr %>% plot(xlab = "Recall",
               ylab = "Precision",
               legend = FALSE)

my_pr$auc.integral
#> [1] 0.8469525

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

my_enc <- my_data %>% dummyVars(formula = Survived ~ Class)
my_data2 <- my_enc %>%
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

## 10.4 ロジスティック回帰

curve(1 / (1 + exp(-x)), -6, 6)

library(caret)
library(PRROC)
library(tidyverse)

my_url <- str_c("https://raw.githubusercontent.com/taroyabuki",
                "/fromzero/master/data/titanic.csv")
my_data <- read_csv(my_url)

my_model <- train(form = Survived ~ ., data = my_data, method = "glm",
                  trControl = trainControl(method = "LOOCV"))

coef(my_model$finalModel) %>%
  as.data.frame
#>                      .
#> (Intercept)  2.0438374
#> Class2nd    -1.0180950
#> Class3rd    -1.7777622
#> ClassCrew   -0.8576762
#> SexMale     -2.4200603
#> AgeChild     1.0615424

my_model$results
#>   parameter  Accuracy     Kappa
#> 1      none 0.7782826 0.4448974

