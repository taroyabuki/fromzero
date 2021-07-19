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
