Gpc<-function(name,astar,bk){
  m<-length(bk)
  as<-0:m
  res<-list(name=name,nfac=1,itemtype=3,ncat=m+1,gpc=1,astar=astar,as=as,ak=astar*as,ck=c((astar*TcPC(m+1)) %*% bk),bk=c(0,bk))
  class(res)<-"uirt"
  res
}