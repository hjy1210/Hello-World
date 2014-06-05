TcPC<-function(m) {
  # m=ncat
  mx<-matrix(0,nrow=m,ncol=m-1)
  mx[1,]<-rep(0,m-1)
  for (i in 2:m) {
    for (j in 1:(i-1)) {
      mx[i,j]<- -1
    }
  }
  mx  
}
