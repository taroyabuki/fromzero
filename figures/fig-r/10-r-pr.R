pdf(file = "10-r-pr.pdf", width = 6, height = 5)

library(PRROC)
library(tidyverse)

y       <- c(  0,   1,   1,   0,   1,   0,    1,   0,   0,   1)
y_score <- c(0.7, 0.8, 0.3, 0.4, 0.9, 0.6, 0.99, 0.1, 0.2, 0.5)

my_pr <- pr.curve(scores.class0 = y_score[y == 1],
                    scores.class1 = y_score[y == 0],
                    curve = TRUE)
my_pr %>% plot(xlab = "Recall",
               ylab = "Precision",
               legend = FALSE)
