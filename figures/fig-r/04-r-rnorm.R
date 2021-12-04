pdf(file = "04-r-rnorm.pdf", width = 6, height = 5)

r <- 10000
x <- rnorm(mean = 50, # 平均
           sd = 5,    # 標準偏差
           n = r)     # 乱数の数
hist(x, breaks = 40)
