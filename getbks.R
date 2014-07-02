getBks<-function(items) {
  bk<-numeric(0)
  for (i in seq_along(items)) {
    if (items[[i]]$itemtype==1 || items[[i]]$itemtype==2 || items[[i]]$itemtype==3) bk<-c(bk,items[[i]]$bk)
    else stop("only implement gr and Gpc")
  }
  bk
}
