readCqcItems<-function(file,ncats,itemmeanzero=FALSE){
  cqcItemsIndex<-function(ms,itemmeanzero=FALSE) {
    row<-length(ms)
    n<-sum(ms)
    if (itemmeanzero==TRUE) n<-n-1
    indexes<-matrix(0,nrow=n,ncol=2)
    for (i in 1:(row-1))
      indexes[i,]<- c(i,1)
    if (itemmeanzero!=TRUE) {
      indexes[row,]<-c(row,1)
      nxt<-row+1
    } else {
      nxt<-row
    }
    for (i in 1:row) {
      if (ms[i]>1) {
        for (j in 2:ms[i]) {
          indexes[nxt,]<-c(i,j)
          nxt<-nxt+1
        }
      }
    }  
    indexes
  }
  # modify to no need of tempory file and no need of old parameter matrix
  # use regular expression to manipulate strings
  ms<-ncats-1
  row<-length(ms)
  
  lines<-readLines(file)
  #trim leading/trailing spaces
  lines<-gsub("(^[[:space:]]+|[[:space:]]+$)","",lines)  
  tokens<-strsplit(lines,"[[:space:]]+")
  pars<-lapply(tokens,function(x) as.numeric(x[1:2]))
  pars<-data.frame(pars)
  colnames(pars)<-NULL
  p<-t(as.matrix(pars)) # 2 columns
  
  items<-rep(list(bk=c()),row)
  r<-dim(p)[1]
  for (i in 1:r) {
    n<-p[i,1]
    if (n<=row) items[n]$bk<-p[i,2]
  }
  if (itemmeanzero==TRUE) {
    s<-0
    for (i in 1:(row-1)) s<-s+items[i]$bk
    items[row]$bk<- -s
  }
  
  index<-cqcItemsIndex(ms,itemmeanzero)
  for (i in 1:r) {
    n<-p[i,1]
    items[index[n,1]]$bk[index[n,2]]<-p[i,2]
  }
  for (i in 1:row) {
    if (length(items[i]$bk)>1) {
      s<-sum(items[i]$bk[-1])
      items[i]$bk<-c(items[i]$bk,-s)
    }
  }
  res<-list()
  length(res)<-row
  for (i in 1:row) {
    m<-length(items[i]$bk)
    if (m==1) {
      #tmp<-list(name=paste("V",i,sep=""),nfac=1,itemtype=2,ncat=m+1,a=1,ck=-items[i]$bk,bk=items[i]$bk)
      #class(tmp)<-"uirt"
      tmp<-Gr(paste("V",i,sep=""),a=1,bk=items[i]$bk)
      res[[i]]<-tmp
    } else if (m>1){
      bk<-items[i]$bk[1]+items[i]$bk[-1]
      #tmp<-list(name=paste("V",i,sep=""),nfac=1,itemtype=3,ncat=m,gpc=1,astar=1,as=0:(m-1),ak=0:(m-1),
      #          ck=c(0,-cumsum(bk)),bk=c(0,bk))
      #class(tmp)<-"uirt"
      tmp<-Gpc(name=paste("V",i,sep=""),a=1,bk=bk)
      res[[i]]<-tmp
    }
  }
  res

}
