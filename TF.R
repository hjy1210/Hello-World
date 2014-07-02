TF<-function(m) {
  mx<-matrix(0,nrow=m,ncol=m-1)
  mx[,1]<-seq(0,m-1)
  for (i in 2:(m-1)) {
    for (j in 2:(m-1)) {
      mx[i,j]<-sin(pi*(i-1)*(j-1)/(m-1))
    }
  }
  mx  
}
