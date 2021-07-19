## 7.2 データの確認

library(caret)
library(tidyverse)
my_data <- cars

dim(my_data)
#> [1] 50  2

head(my_data)
#>   speed dist
#> 1     4    2
#> 2     4   10
#> 3     7    4
#> 4     7   22
#> 5     8   16
#> 6     9   10

options(digits = 3)
pastecs::stat.desc(my_data)
#>                speed    dist
#> nbr.val       50.000   50.00
#> nbr.null       0.000    0.00
#> nbr.na         0.000    0.00
#> min            4.000    2.00
#> max           25.000  120.00
#> range         21.000  118.00
#> sum          770.000 2149.00
#> median        15.000   36.00
#> mean          15.400   42.98
#> SE.mean        0.748    3.64
#> CI.mean.0.95   1.503    7.32
#> var           27.959  664.06
#> std.dev        5.288   25.77
#> coef.var       0.343    0.60

my_data %>%
  ggplot(aes(x = speed, y = dist)) +
  geom_point()
