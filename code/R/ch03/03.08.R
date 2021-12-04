## 3.8 その他

### 3.8.1 よく遭遇するエラーとその対処方法

### 3.8.2 変数や関数についての調査

x <- 123
typeof(x)
#> [1] "double"

?log
# あるいは
help(log)

### 3.8.3 RのNA，Pythonのnan

v <- c(1, NA, 3)
v
#> [1]  1 NA  3

is.na(v[2])
#> [1] TRUE

v[2] == NA # 誤り
#> [1] NA
