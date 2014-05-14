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
