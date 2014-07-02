Gpc<-function(name,a,bk){
  pdf<-function(thetas){
    den<-1
    num<-matrix(0,nrow=length(thetas),ncol=ncat)
    num[,1]<-1
    for (i in 2:ncat) {
      num[,i]<-exp(ak[i]*thetas+ck[i])
      den<-den+num[,i]
    }
    for (i in 1:ncat) {
      num[,i]<-num[,i]/den
    }
    num
  }
  m<-length(bk)
  ncat<-m+1
  as<-0:m
  ak<-a*as
  ck<-c((a*TcPC(m+1)) %*% bk)
  res<-list(name=name,nfac=1,itemtype=3,ncat=ncat,gpc=1,a=a,as=as,ak=ak,ck=ck,bk=bk,pdf=pdf)
  class(res)<-"uirt"
  res
}