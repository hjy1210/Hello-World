writeCqcItems<-function(items,rows,file){
  inf<-character(0)
  row<-length(items)
  ndx<-1
  for (i in 1:row) {
    if (rows[i]==TRUE) inf<-c(inf,paste(ndx,mean(items[[i]]$bk),"/* item",i,"*/"))
    ndx<-ndx+1
  }
  for (i in 1:row) {
    m<-items[[i]]$ncat-1
    if (m>1){
      for (j in 2:m) {
        mu<-mean(items[[i]]$bk)
        if (rows[i]==TRUE) inf<-c(inf,paste(ndx,(items[[i]]$bk)[j-1]-mu,"/* item",i,"step",j-1,"*/"))
        ndx<-ndx+1
      }
    }
  }
  write.table(inf,file,row.names=FALSE,col.names=FALSE,quote=FALSE)
}
