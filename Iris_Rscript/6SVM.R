library("MASS")
#-----------------------------------Iris data------------------------#

start.time <- Sys.time()

v.1 <- read.table ("/home/hduser/Documents/R/Iris_output/Iris-setosa.txt", sep = "")
v.2 <- read.table ("/home/hduser/Documents/R/Iris_output/Iris-virginica.txt", sep = "")

ff12.1 <- c (v.1[,1], v.1[,2])
m1 <- matrix(ff12.1,ncol=2,byrow=FALSE)
label.1 <- rep(1, nrow(m1))
m1 <- cbind(m1,label.1)

ff12.2 <- c (v.2[,1], v.2[,2])
m2 <- matrix(ff12.2,ncol=2,byrow=FALSE)
label.2 <- rep(-1, nrow(m2))
m2 <- cbind(m2,label.2)

mb <- rbind(m1,m2)

# mb <- matrix(c(5.5,5.7,6.1,4.5,4.3,1.5,0.5,1.1,-1.8,-1.5,1,1,1,-1,-1),nrow=5,ncol=3)

#----------extract features and label---------------------------------#

m_ff <- mb[,c(1,2)]
m_label <- mb[,3]

#----------normalization----------------------------------------------#

m_sd <- apply(m_ff,2,sd,na.rm = TRUE)
m_mean <- colMeans(m_ff, na.rm = TRUE)

for (i in 1:ncol(m_ff)){
  m_ff[,i] = (m_ff[,i]-m_mean[i])/m_sd[i]
}

#------------------------append indentity matrix----------------------------------#

m.indx <- nrow(m_ff)
n.indx <- ncol(m_ff)
m_ff.right <- matrix(rep(0,m.indx*n.indx),nrow=m.indx,ncol=n.indx)
m_ff.app <- cbind(m_ff,m_ff.right)
m_ff.down <- diag(n.indx*2)
m_ff.app <- rbind(m_ff.app,m_ff.down)
m_ff.IM <- -diag(n.indx)
m_ff.app[c(m.indx+n.indx+1,m.indx+n.indx*2),c(1,2)] <- m_ff.IM

#-----------------------------sqrt---------------------------------#

lamda <- 0.95
lamda.matrix <- 1/lamda*diag(2)
lamda.right <- matrix(rep(0,n.indx*n.indx),nrow=n.indx,ncol=n.indx)
lamda.down <- matrix(rep(0,n.indx*n.indx*2),nrow=n.indx,ncol=n.indx*2)
lamda.matrix <- cbind(lamda.matrix,lamda.right)
lamda.matrix <- rbind(lamda.matrix,lamda.down)
lamda.matrix <- sqrt(lamda.matrix)

#--------------------------------matrix A------------------------------#

A.matrix <- m_ff.app %*% lamda.matrix

#--------------------9by9 matrix------------------------------------------#

m.append <- matrix(rep(1,n.indx*2),nrow=1,ncol=n.indx*2)
m_label = t(m_label)
m_label.app <- cbind(m_label,m.append)
m.length <- length(m_label.app)
D.matrix <- matrix(rep(0,m.length*m.length),nrow=m.length,ncol=m.length)

for (j in 1:nrow(D.matrix)){
  
      D.matrix[j,j] = m_label.app[j]
}

#--------------------------9by5------------------------------------#

E.matrix <- matrix(c(rep(1,m.indx),rep(0,n.indx*2)),nrow=m.indx+n.indx*2,ncol=1)
E.negative <- -E.matrix
C.matrix <- cbind(A.matrix,E.negative)

#--------------------------H.matrix, S.matrix------------------------------------#

H.matrix <- D.matrix %*% C.matrix
n.A <- ncol(A.matrix)
nu <- 1
it <- 0
itmax <- 1000
tol <- 0.001
alpha <- 1.9/nu
S.matrix <- H.matrix %*% ginv(diag(n.A+1)/nu + t(H.matrix)%*%H.matrix)

#--------------------------LSVM--------------------------------------#

u <- nu * (1-S.matrix %*% (t(H.matrix) %*% E.matrix))
oldu <- u + 1

p1.fn <- function(x){
  p1 <- (abs(x)+x)/2
  return(p1)
}

while ((it<itmax) && (rnorm(oldu-u)>tol)){
  z <- (1+p1.fn(((u/nu+H.matrix%*%(t(H.matrix)%*%u))-alpha*u)-1))
  oldu <- u
  u <- nu*(z-S.matrix%*%(t(H.matrix)%*%z))
  it <- it + 1
}

opt = rnorm(n.A-oldu)
w = t(A.matrix)%*%D.matrix%*%u
gamma = -t(E.matrix)%*%D.matrix%*%u

w1 <- w[1]+w[3]  ## w1=0.9678463
w2 <- w[2]+w[4]  ## w2=-0.4819838  gamma = -0.09138648

#------------------------plot----------------------------------------#

weight.w1 <- w1  
weight.w2 <- w2  

m1_row <- nrow(m1)
m2_row <- nrow(m2)
x1 <- m_ff[c(1:m1_row),1]
y1 <- m_ff[c(1:m1_row),2]
x2 <- m_ff[c((m1_row+1):(m1_row+m2_row)),1]
y2 <- m_ff[c((m1_row+1):(m1_row+m2_row)),2]
x <- m_ff[c(1:m.indx),1]
y = (gamma - x * weight.w1) / weight.w2

pdf("/home/hduser/Documents/R/Iris_output/6SVM.pdf")
plot(x,y,type="b", pch =18,
     xlab ='sepal length(cm)',ylab ='sepal width(cm)',
     main = 'Class Iris-setosa(red) and Iris-virginic(blue)')
par(new=TRUE)
points(x1,y1,col="red", pch =1)
par(new=TRUE)
points(x2,y2,col="blue", pch =5)
dev.off()

####---------------time computation---------------------####
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken  #10.3319 secs



