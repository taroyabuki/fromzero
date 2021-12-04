pdf(file = "13-r-kmeans.pdf", width = 5.83, height = 4.13)

library(tidyverse)
library(factoextra)

my_data <- iris[, -5]

f <- 2:5 %>% map(function(k) {
  my_data %>% kmeans(k) %>%
    fviz_cluster(data = my_data, geom = "point") +
    ggtitle(sprintf("k = %s", k))
})
gridExtra::grid.arrange(f[[1]], f[[2]], f[[3]], f[[4]], ncol = 2)
