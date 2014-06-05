getBks<-function(items) {
  bk<-numeric(0)
  for (i in seq_along(items)) {
    if (items[[i]]$itemtype==2) bk<-c(bk,items[[i]]$bk)
    else if (items[[i]]$itemtype==3) bk<-c(bk,items[[i]]$bk[-1])
  }
  bk
}
