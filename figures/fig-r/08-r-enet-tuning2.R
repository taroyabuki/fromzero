pdf(file = "08-r-enet-tuning2.pdf", width = 6, height = 4.5)

library(furrr)
plan(multisession)

library(tidyverse)
my_url <- str_c("https://raw.githubusercontent.com",
                "/taroyabuki/fromzero/master/data/wine.csv")
my_data <- read_csv(my_url)

my_sd <- function(x) { # √標本分散を計算する関数
  n <- length(x)
  sd(x) * sqrt((n - 1) / n)
}

my_loocv <- function(A, B) {
  my_predict <- function(id) {
    my_train <- my_data[-id, ]
    my_valid <- my_data[ id, ]
    y <- my_train$LPRICE2
    u <- mean(y)
    s <- my_sd(y)
    my_train2 <- my_train %>% mutate(LPRICE2 = (y - u) / s)
    my_model <-
      glmnetUtils::glmnet(
        form = LPRICE2 ~ ., data = my_train2,
        lambda = A,  alpha = B, standardize = TRUE)
    (my_model %>% predict(my_valid, exact = TRUE) * s + u)[1]
  }
  y  <- my_data$LPRICE2
  y_ <- seq_len(length(y)) %>% map_dbl(my_predict)
  rmse <- mean((y_ - y)^2)^0.5
  list(A = A, B = B, RMSE = rmse)
}

As <- seq(0, 0.1, length.out = 21)
Bs <- seq(0, 0.1, length.out = 6)
my_params <- expand.grid(A = As, B = Bs)

tmp <- my_params %>% future_pmap_dfr(my_loocv)

my_result <- tmp %>%
  mutate(B = as.factor(B)) %>%
  group_by(A, B) %>%
  summarise(RMSE = mean(RMSE), .groups = "drop")

my_result %>% filter(RMSE == min(RMSE))

my_result %>% ggplot(aes(x = A, y = RMSE, color = B)) +
  geom_point() +
  geom_line() +
  theme(legend.position = c(0, 0),
        legend.justification = c(0, 0)) +
  xlab("A ( = lambda)") +
  guides(color = guide_legend("B ( = alpha)"))
