TF<-function(m,plot=FALSE) {
  mx<-matrix(0,nrow=m,ncol=m-1)
  mx[,1]<-seq(0,m-1)
  for (i in 2:(m-1)) {
    for (j in 2:(m-1)) {
      mx[i,j]<-sin(pi*(i-1)*(j-1)/(m-1))
    }
  }
  if (plot==TRUE) {
    x<-seq(0,m-1,len=201)
    plot(0,0,type="n",xlim<-c(0,m-1),ylim=c(-1,m-1))
    lines(x,x)
    for (i in 2:(m-1)) lines(x,sin(pi*x*(i-1)/(m-1)))
  }
  mx  
}
