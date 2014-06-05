pdf.gr<-function(obj,xpoints,prepend="") {
  #obj<-obj[[1]]
  f<-function(k,thetas) {
    1/(1+exp(-obj$a*thetas-obj$ck[k]))
  }
  ncat<-obj$ncat
  num<-matrix(0,nrow=length(xpoints),ncol=ncat)
  num[,1]<-1-f(1,xpoints)
  if (ncat>2) {
    for (i in 2:(ncat-1)) {
      num[,i]<-f(i-1,xpoints)-f(i,xpoints)
    }
  }
  num[,ncat]<-f(ncat-1,xpoints)
  num
}
