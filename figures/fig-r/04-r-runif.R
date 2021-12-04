pdf(file = "04-r-runif.pdf", width = 6, height = 5)

x <- runif(min = 0,  # 最小
           max = 1,  # 最大
           n = 1000) # 乱数の数
hist(x)
