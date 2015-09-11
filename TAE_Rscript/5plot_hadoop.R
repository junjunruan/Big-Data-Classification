Sys.setenv(HADOOP_HOME='/usr/local/hadoop')
Sys.setenv(HADOOP_CMD='/usr/local/hadoop/bin/hadoop')
Sys.setenv(HADOOP_STREAMING='/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.2.0.jar')

v1 <- read.table ("/home/hduser/Documents/R/TAE_output/f2.txt", sep = "")
v2 <- read.table ("/home/hduser/Documents/R/TAE_output/f3.txt", sep = "")
v3 <- read.table ("/home/hduser/Documents/R/TAE_output/f5.txt", sep = "")
data <- cbind(v1,v2,v3)

library(rmr2)
library(rhdfs)
library(scatterplot3d)

hdfs.init()

data.content <- to.dfs(data)

data.map.fn <- function(k,v){
  key <- 1
  v1 <- v[,1]
  v2 <- v[,2]
  v3 <- v[,3]
  f1 = t(v1)
  f2 = t(v2)
  f3 = t(v3)
  
  v_row <- nrow(v)
  
  ###------------------------plot 2d-------------------------###
  
  pdf("/home/hduser/Documents/R/TAE_output/5plot2d_hadoop.pdf")
  plot(f1,f2, col=c(rep("red",v_row/2),rep("blue",v_row/2)),type="p", pch =20, 
       xlab='Course instructor categories', ylab='course categories',
       xlim = c(0,30),ylim = c(0,30),
       main = "Class medium(red) and high(blue)")
  dev.off()
  
  ##----------------------------plot 3d---------------------------##
  
  pdf("/home/hduser/Documents/R/TAE_output/5plot3d_hadoop.pdf")
  scatterplot3d(v[,1],v[,2],v[,3],color=c(rep("red",v_row/2),rep("blue",v_row/2)),pch=20,type="p",
                xlab="Course instructor categories",
                ylab="course categories",zlab="Class size",
                main = "Class medium(red) and high(blue)")
  dev.off()

  val <- 1
  keyval(key,val)
}

data.reduce.fn <- function(k,v){
  keyval(k,v)
}

classify <- mapreduce(input=data.content,
                      map=data.map.fn,
                      reduce=data.reduce.fn)

from.dfs(classify)

