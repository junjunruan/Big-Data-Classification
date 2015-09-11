
v.1 <- read.table ("/home/hduser/Documents/R/Iris_output/Testing-Iris-setosa.txt", sep = "")
v.2 <- read.table ("/home/hduser/Documents/R/Iris_output/Testing-Iris-virginica.txt", sep = "")

##--------normalization---------------------------##

ff12.1 <- c (v.1[,1], v.1[,2])
m1 <- matrix(ff12.1,ncol=2,byrow=FALSE)

ff12.2 <- c (v.2[,1], v.2[,2])
m2 <- matrix(ff12.2,ncol=2,byrow=FALSE)

mb <- rbind(m1,m2)

m_sd <- apply(mb,2,sd,na.rm = TRUE)
m_mean <- colMeans(mb, na.rm = TRUE)

for (i in 1:ncol(mb)){
  mb[,i] = (mb[,i]-m_mean[i])/m_sd[i]
}

m1_row <- nrow(m1)
m2_row <- nrow(m2)
x1 <- mb[c(1:m1_row),1]
y1 <- mb[c(1:m1_row),2]
x2 <- mb[c((m1_row+1):(m1_row+m2_row)),1]
y2 <- mb[c((m1_row+1):(m1_row+m2_row)),2]

##--------------function from LSVM in step 6------------------------------##
w1 <- 0.9678463
w2 <- -0.4819838
gamma <- -0.09138648
x <- mb[,1]
y = (gamma - x * w1) / w2

##----------------plot---------------------------------------##

pdf("/home/hduser/Documents/R/Iris_output/test.pdf")
plot(x,y,type="b", pch =18,
     xlab ='sepal length(cm)',ylab ='sepal width(cm)',
     main = 'Class Iris-setosa(red) and Iris-virginic(blue)')
par(new=TRUE)
points(x1,y1,col="red", pch =1)
par(new=TRUE)
points(x2,y2,col="blue", pch =5)
dev.off()