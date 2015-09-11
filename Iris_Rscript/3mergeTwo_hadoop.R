Sys.setenv(HADOOP_HOME='/usr/local/hadoop')
Sys.setenv(HADOOP_CMD='/usr/local/hadoop/bin/hadoop')
Sys.setenv(HADOOP_STREAMING='/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.2.0.jar')

start.time <- Sys.time()

data <- read.table ("/home/hduser/Documents/R/Iris_output/iris.data.txt", sep = "")

library(rmr2)
library(rhdfs)

hdfs.init()

data.content <- to.dfs(data)

data.map.fn <- function(k,v){
  key <- 1
  class <- unique (v[,5])
  c2 <- sample(class, 2, replace=FALSE)
  m1 <- read.table (paste("/home/hduser/Documents/R/Iris_output/",c2[1],".txt", sep=""))
  m2 <- read.table (paste("/home/hduser/Documents/R/Iris_output/",c2[2],".txt", sep=""))
  val <- rbind(m1, m2)
  keyval(key,val)
}

data.reduce.fn <- function(k,v){  
  keyval(k,v)
  write.table(v,paste("/home/hduser/Documents/R/Iris_output/cc12_hadoop.txt"))
}

classify <- mapreduce(input=data.content,
                      map=data.map.fn,
                      reduce=data.reduce.fn)

from.dfs(classify)

end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken  #46.25848 secs

