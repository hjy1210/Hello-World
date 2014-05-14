tcc<-function(items,scores,xrange,npoints){
  x<-seq(xrange[1],xrange[2],len=npoints)
  acc<-numeric(length(x))
  for (i in seq_along(items)) {
    ncat<-items[[i]]$ncat
    if (items[[i]]$itemtype==3) {
      pdf<-pdf.gpc(items[[i]],xrange,npoints)
    }
    else if(items[[i]]$itemtype==2) {
      pdf<-pdf.gr(items[[i]],xrange,npoints)
    }
    for (j in 1:ncat) {
      acc<-acc+pdf$y[,j]*(j-1)*scores[i]/(ncat-1)
    }
  }
  list(x=x,y=acc)
}
