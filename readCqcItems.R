readCqcItems<-function(file,ncats,itemmeanzero=FALSE){
  ms<-ncats-1
  row<-length(ms)
  col<-max(ms)
  form<- matrix(NA,nrow=row,ncol=col)
  
  lines<-read.table(file,header=FALSE,sep="\n")
  tokens<-strsplit(as.character(lines[[1]]),c("/"))
  clr<-c()
  for (i in 1:length(tokens)) clr=c(clr,tokens[[i]][1])
  write.table(clr,"tmp.txt",row.names=FALSE,col.names=FALSE,quote=FALSE)
  p<-read.table(file="tmp.txt",header=FALSE)
  
  items<-rep(NA,row)
  for (i in 1:length(p[[1]])) {
    n<-p[[1]][i]
    if (n<=row) items[n]<-p[[2]][i]
  }
  if (itemmeanzero==TRUE) items[row]<- -sum(items[1:(row-1)])
  
  index<-cqcItemsIndex(ms,itemmeanzero)
  form[,1]<-items
  for (i in 1:length(p[[1]])) {
    n<-p[[1]][i]
    form[index[n,1],index[n,2]]<-p[[2]][i]
  }
  if (col>1) {
    for (i in 1:row) {
      if (!is.na(form[i,2])) {
        s<-0
        for (j in 2:col) {
          if (!is.na(form[i,j])) {
            form[i,j-1]<-items[i]+form[i,j]
            s<- s-form[i,j]
          }
          else
            form[i,j]<-items[i]+s
        }
        if (!is.na(form[i,col]))
          form[i,col]<-items[i]+s
      }
    }
  }
  #form
  res<-list()
  length(res)<-row
  for (i in 1:row) {
    m<-sum(!is.na(form[i,]))
    if (m==1) {
      tmp<-list(name=paste("V",i,sep=""),nfac=1,itemtype=2,ncat=m+1,a=1,ck=-form[i,1:m])
      class(tmp)<-"uirt"
      res[[i]]<-tmp
    } else {
      tmp<-list(name=paste("V",i,sep=""),nfac=1,itemtype=3,ncat=m+1,gpc=1,astar=1,as=0:m,ak=0:m,ck=c(0,-cumsum(form[i,(1:m)])))
      class(tmp)<-"uirt"
      res[[i]]<-tmp
    }
  }
  res
}
