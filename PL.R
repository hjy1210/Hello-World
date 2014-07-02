PL<-function(name,a,bk,lg) {
  pdf<-function(thetas) {
    f<-function(thetas) {
      g+(1-g)*1/(1+exp(-a*thetas-ck))
    }
    num<-matrix(0,nrow=length(thetas),2)
    num[,2]<-f(thetas)
    num[,1]<-1-num[,2]
    num
  }
  ck<- -bk[1]*a
  g<-1/(1+exp(-lg))
  ncat<-2
  res<-list(name=name,nfac=1,itemtype=1,ncat=ncat,a=a,ck=ck,bk=bk,g=g,pdf=pdf)
  class(res)<-"uirt"
  res
}