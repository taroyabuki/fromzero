pdf(file = "13-r-hclust.pdf", width = 5.83, height = 4.13)

my_data <- data.frame(
  x = c(  0, -16,  10,  10),
  y = c(  0,   0,  10, -15),
  row.names = c("A", "B", "C", "D"))

my_dist <- dist(my_data)
my_result <- hclust(my_dist)

factoextra::fviz_dend(
  my_result,
  k = 3,
  rect = T, rect_fill = T)
