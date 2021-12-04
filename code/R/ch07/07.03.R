## 7.3 回帰分析

### 7.3.1 回帰分析とは何か

### 7.3.2 線形単回帰分析

library(tidyverse)

my_data <- cars
tmp <- data.frame(speed = 21.5, dist = 67)
my_data %>% ggplot(aes(x = speed, y = dist)) +
  coord_cartesian(xlim = c(4, 25), ylim = c(0, 120)) +
  geom_point() +
  stat_smooth(formula = y ~ x, method = "lm") +
  geom_pointrange(data = tmp, aes(ymin = -9, ymax = dist),  linetype = "dotted") +
  geom_pointrange(data = tmp, aes(xmin =  0, xmax = speed), linetype = "dotted")

### 7.3.3 回帰分析の実践

#### 7.3.3.1 データの用意

library(caret)
library(tidyverse)
my_data <- cars

#### 7.3.3.2 訓練

my_model <- train(form = dist ~ speed, # モデル式（出力変数と入力変数の関係）
                  data = my_data,      # データ
                  method = "lm")       # 手法

coef(my_model$finalModel)
#> (Intercept)       speed
#> -17.579095    3.932409

#### 7.3.3.3 予測

tmp <- data.frame(speed = 21.5)
my_model %>% predict(tmp)
#>        1
#> 66.96769

#### 7.3.3.4 モデルの可視化

f <- function(x) { my_model %>% predict(data.frame(speed = x)) }

my_data %>%
  ggplot(aes(x = speed, y = dist,
             color = "data")) +
  geom_point() +
  stat_function(
    fun = f,
    mapping = aes(color = "model"))
