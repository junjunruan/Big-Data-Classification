start.time <- Sys.time()

v <- read.table ("/home/hduser/Documents/R/TAE_output/tae.data.txt", sep = "")

class <- unique (v[,6])

c2 <- sample(class, 2, replace=FALSE)
c2
m1 <- read.table(paste("/home/hduser/Documents/R/TAE_output/",c2[1],".txt", sep=""))
m2 <- read.table(paste("/home/hduser/Documents/R/TAE_output/",c2[2],".txt", sep=""))
com <- rbind(m1, m2)
write.table(com,paste("/home/hduser/Documents/R/TAE_output/cc12.txt"))


end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken  #0.1365235 secs
