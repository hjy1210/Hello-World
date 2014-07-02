Gr<-function(name,a,bk) {
  pdf<-function(thetas) {
    f<-function(k,thetas) {
      1/(1+exp(-a*thetas-ck[k]))
    }
    num<-matrix(0,nrow=length(thetas),ncol=ncat)
    num[,1]<-1-f(1,thetas)
    if (ncat>2) {
      for (i in 2:(ncat-1)) {
        num[,i]<-f(i-1,thetas)-f(i,thetas)
      }
    }
    num[,ncat]<-f(ncat-1,thetas)
    num
  }
  ck<- -bk*a
  ncat<-length(bk)+1
  res<-list(name=name,nfac=1,itemtype=2,ncat=ncat,a=a,ck=ck,bk=bk,pdf=pdf)
  class(res)<-"uirt"
  res
}