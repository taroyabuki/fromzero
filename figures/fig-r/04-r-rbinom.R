pdf(file = "04-r-rbinom.pdf", width = 6, height = 5)

n <- 100
p <- 0.5
r <- 10000
x <- rbinom(size = n, # 試行回数
            prob = p, # 確率
            n = r)    # 乱数の数
hist(x, breaks = max(x) - min(x))
