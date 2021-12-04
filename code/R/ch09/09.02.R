## 9.2 木による分類

### 9.2.1 分類木の作成と利用

library(caret)
library(tidyverse)
my_data <- iris
my_model <- train(form = Species ~ ., data = my_data, method = "rpart")

rpart.plot::rpart.plot(my_model$finalModel, extra = 1)

my_test <- tribble(
~Sepal.Length, ~Sepal.Width, ~Petal.Length, ~Petal.Width,
          5.0,          3.5,           1.5,          0.5,
          6.5,          3.0,           5.0,          2.0)

my_model %>% predict(my_test)
#> [1] setosa    virginica
#> Levels: setosa versicolor virginica

my_model %>% predict(my_test,
                     type = "prob")
#>   setosa versicolor virginica
#> 1      1 0.00000000 0.0000000
#> 2      0 0.02173913 0.9782609
