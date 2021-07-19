## 8.2 重回帰分析

library(caret)
library(tidyverse)
my_url <- str_c("https://raw.githubusercontent.com/taroyabuki",
                "/fromzero/master/data/wine.csv")
my_data <- read_csv(my_url)

my_model <- train(form = LPRICE2 ~ WRAIN + DEGREES + HRAIN + TIME_SV,
                  data = my_data,
                  method = "lm",
                  trControl = trainControl(method = "LOOCV"))

coef(my_model$finalModel) %>%
  as.data.frame
#>                         .
#> (Intercept) -12.145333577
#> WRAIN         0.001166782
#> DEGREES       0.616392441
#> HRAIN        -0.003860554
#> TIME_SV       0.023847413

my_test <- data.frame(
  WRAIN = 500, DEGREES = 17,
  HRAIN = 120, TIME_SV = 2)
my_model %>% predict(my_test)
#>         1
#> -1.498843

y  <- my_data$LPRICE2
y_ <- my_model %>% predict(my_data)

RMSE(y_, y)
#> [1] 0.2586167 # RMSE（訓練）

R2(pred = y_, obs = y,
   form = "traditional")
#> [1] 0.8275278 # 決定係数1（訓練）

R2(pred = y_, obs = y,
   form = "corr")
#> [1] 0.8275278 # 決定係数6（訓練）

my_model$results
#>   intercept      RMSE  Rsquared       MAE
#> 1      TRUE 0.3230043 0.7361273 0.2767282

### 8.2.1 補足：行列計算による再現

M <- my_data[, -1] %>%
  mutate(b0 = 1) %>% as.matrix
b <- MASS::ginv(M) %*% y
matrix(b,
       dimnames = list(colnames(M)))
#>                  [,1]
#> WRAIN     0.001166782
#> DEGREES   0.616392441
#> HRAIN    -0.003860554
#> TIME_SV   0.023847413
#> b0      -12.145333577
