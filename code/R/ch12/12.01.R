## 12.1 日時と日時の列

### 12.1.1 日時

as.POSIXct("2021-01-01")
#> [1] "2021-01-01 JST"

### 12.1.2 等間隔の日時

library(tsibble)

seq(from = 2021, to = 2023, by = 1)
#> [1] 2021 2022 2023

seq(from = yearmonth("202101"), to = yearmonth("202103"), by = 2)
#> <yearmonth[2]>
#> [1] "2021 1" "2021 3"

seq(from = as.POSIXct("2021-01-01"), to = as.POSIXct("2021-01-03"), by = "1 day")
#> [1] "2021-01-01 JST" "2021-01-02 JST" "2021-01-03 JST"

seq(from = as.POSIXct("2021-01-01 00:00:00"),
    to   = as.POSIXct("2021-01-01 03:00:00"), by = "2 hour")
#> [1] "2021-01-01 00:00:00 JST" "2021-01-01 02:00:00 JST"
