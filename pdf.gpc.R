pdf.gpc<-function(obj,xpoints,prepend="") {
  #obj<-obj[[1]]
  ncat<-obj$ncat
  den<-1
  num<-matrix(0,nrow=length(xpoints),ncol=ncat)
  num[,1]<-1
  for (i in 2:ncat) {
    num[,i]<-exp(obj$ak[i]*xpoints+obj$ck[i])
    den<-den+num[,i]
  }
  for (i in 1:ncat) {
    num[,i]<-num[,i]/den
  }
  num
}
