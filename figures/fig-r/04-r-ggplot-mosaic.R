pdf(file = "04-r-ggplot-mosaic.pdf", width = 6, height = 4)

library(tidyverse)

library(ggmosaic)
my_df <- data.frame(
  Species = iris$Species,
  w_Sepal = iris$Sepal.Width > 3)
my_df %>%
  ggplot() +
  geom_mosaic(
    aes(x = product(w_Sepal,
                    Species)))
