tcc<-function(items,scores,xpoints){
  acc<-numeric(length(xpoints))
  for (i in seq_along(items)) {
    ncat<-items[[i]]$ncat
    if (items[[i]]$itemtype==3 || items[[i]]$itemtype==2 || items[[i]]$itemtype==1) {
      pdf<-items[[i]]$pdf(xpoints)
    }
    else stop("only implement gr and gpc")
    for (j in 1:ncat) {
      acc<-acc+pdf[,j]*scores[[i]][j]
    }
  }
  acc
}
