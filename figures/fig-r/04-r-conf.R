pdf(file = "04-r-conf.pdf", width = 6, height = 5.5)

library(exactci)

a <- 0.05                              # 有意水準
binom.exact(x = 2,                     # 当たった回数
            n = 15,                    # くじを引いた回数
            p = 4 / 10,                # 当たる確率（仮説）
            plot = TRUE,               # p値の描画
            conf.level = 1 - a,        # 信頼係数（デフォルト）
            tsmethod = "minlike",      # 両側p値の使用
            alternative = "two.sided") # 両側検定（デフォルト）
                                       # 左片側検定なら'less'
                                       # 右片側検定なら'greater'
