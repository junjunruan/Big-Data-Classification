library(rgl)

start.time <- Sys.time()

v1 <- read.table ("/home/hduser/Documents/R/TAE_output/f2.txt", sep = "")
v2 <- read.table ("/home/hduser/Documents/R/TAE_output/f3.txt", sep = "")
v1.row <- nrow(v1)

f1 <- t(v1)
f2 <- t(v2)

######---------------------plot 2d graph--------------------------------#####

pdf("/home/hduser/Documents/R/TAE_output/5plot2d.pdf")
plot(f1, f2, col=c(rep("red",v_row/2),rep("blue",v_row/2)),type="p", pch =1, 
     xlab='Course instructor categories', ylab='course categories',
     xlim = c(0,30),ylim = c(0,30),
     main = "Class medium(red) and high(blue)")
dev.off()

#########------------plot 3d graph ----------------------------------------####

open3d()
v3 <- read.table ("/home/hduser/Documents/R/TAE_output/f5.txt", sep = "")
f3 <- t(v3)

plot3d(f1,f2,f3,
       xlab="Course instructor categories",
       ylab="course categories",zlab="Class size",
       col=c(rep("red",v_row/2),rep("blue",v_row/2)),
       main = "Class medium(red) and high(blue)")

rgl.postscript("/home/hduser/Documents/R/TAE_output/5plot3d.pdf","pdf")

end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken  #12.85115 secs
