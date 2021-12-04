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
