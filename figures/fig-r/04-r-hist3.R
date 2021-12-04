pdf(file = "04-r-hist3.pdf", width = 6, height = 5.5)

x <- iris$Sepal.Length
tmp <- seq(min(x), max(x),
           length.out = 10)
hist(x, breaks = tmp, right = FALSE)
