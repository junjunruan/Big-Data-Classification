library(rgl)

start.time <- Sys.time()

#Extract feature 1, 2 and 3

v1 <- read.table ("/home/hduser/Documents/R/Iris_output/f1.txt", sep = "")
v2 <- read.table ("/home/hduser/Documents/R/Iris_output/f2.txt", sep = "")
v3 <- read.table ("/home/hduser/Documents/R/Iris_output/f3.txt", sep = "")

f1 <- t(v1)
f2 <- t(v2)
f3 <- t(v3)

v_row <- nrow(v1)

######---------------------plot 2d graph--------------------------------#####

pdf("/home/hduser/Documents/R/Iris_output/5plot2d.pdf")
plot(f1, f2, col=c(rep("red",v_row/2),rep("blue",v_row/2)),type="p", pch =20, 
     xlab='sepal length(cm)', ylab='sepal width(cm)',
     main = "Class Iris-setosa(red) and Iris-virginica(blue)")
dev.off()

#########------------plot 3d graph ----------------------------------------####

open3d()

plot3d(f1,f2,f3,
       xlab="sepal length(cm)",
       ylab="sepal width(cm)",zlab="petal length(cm)",
       col=c(rep("red",v_row/2),rep("blue",v_row/2)),
       main = "Class Iris-setosa(red) and Iris-virginica(blue)")

rgl.postscript("/home/hduser/Documents/R/Iris_output/5plot3d.pdf","pdf")

###--------------time comsuming----------------------##

end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken  #1.453966 secs
