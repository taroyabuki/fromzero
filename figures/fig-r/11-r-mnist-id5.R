pdf(file = "11-r-mnist-id5.pdf", width = 5.83, height = 4.13)

library(keras)
c(c(x_train, y_train), c(x_test, y_test)) %<-% dataset_mnist()

plot(as.raster(x = x_train[5, , ], max = max(x_train)))
