pdf(file = "13-r-elbow.pdf", width = 6, height = 4.5)

library(tidyverse)
library(factoextra)

my_data <- iris[, -5]
fviz_nbclust(my_data, kmeans, method = "wss")
