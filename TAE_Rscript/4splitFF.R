v <- read.table ("/home/hduser/Documents/R/TAE_output/cc12.txt", sep = "")
ff.num <- ncol(v)

for (i in 1:ff.num){
  write.table(v[,i],paste("/home/hduser/Documents/R/TAE_output/f",toString(i),".txt",sep=""))
}