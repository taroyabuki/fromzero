pdf(file = "04-r-random-sample.pdf", width = 6, height = 5)

x <- sample(x = 1:6,        # 範囲
            size = 10000,   # 乱数の数
            replace = TRUE) # 重複あり
hist(x, breaks = 0:6) # ヒストグラム
