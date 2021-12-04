pdf(file = "04-r-boot-binom.pdf", width = 6, height = 5)

X <- rep(0:1, c(13, 2))
n <- 10^5
result <- replicate(n, sum(sample(X, size = length(X), replace = TRUE)))
hist(x = result,
     breaks = 0:15,
     right = FALSE)
