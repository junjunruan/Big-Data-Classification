#####-------------function for increasing data-----------------#####
val.fn <-function(m){
  
  ff.num <- ncol(m)
  ff.increase <- 5000
  
  col.min <- matrix(rep(0,ff.num),nrow=1,ncol=ff.num)
  col.max <- matrix(rep(0,ff.num),nrow=1,ncol=ff.num)
  col.next <- matrix(rep(0,ff.num*ff.increase),nrow=ff.increase,ncol=ff.num)
  
  for (i in 1:ff.num){
    col.min[i] <- min(m[,i])
    col.max[i] <- max(m[,i])
    col.next[,i] <- col.min[i] + (col.max[i]-col.min[i])*runif(ff.increase,0,1)
  }
  
  col.next <- round(col.next,1)
  val <- rbind (m, col.next)
  return(val)
}


#####-----increase features in class Iris-virginica------------#####

m1 <- read.table ("/home/hduser/Documents/R/Iris_output/Iris-virginica.txt", sep = "")
val1 <- val.fn(m1)
write.table(val1,paste("/home/hduser/Documents/R/Iris_output/Iris-virginica.txt"))

########----------increase features in class Iris-setosa-------------------####

m2 <- read.table ("/home/hduser/Documents/R/Iris_output/Iris-setosa.txt", sep = "")
val2 <- val.fn(m2)
write.table(val2,paste("/home/hduser/Documents/R/Iris_output/Iris-setosa.txt"))

########----------increase features in class Iris-versicolor------------------####

m3 <- read.table ("/home/hduser/Documents/R/Iris_output/Iris-versicolor.txt", sep = "")
val3 <- val.fn(m3)
write.table(val3,paste("/home/hduser/Documents/R/Iris_output/Iris-versicolor.txt"))


