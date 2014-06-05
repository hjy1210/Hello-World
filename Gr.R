Gr<-function(name,a,bk) {
  res<-list(name=name,nfac=1,itemtype=2,ncat=length(bk)+1,a=a,ck=-bk*a,bk=bk)
  class(res)<-"uirt"
  res
}