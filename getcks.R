getCks<-function(items) {
  ck<-numeric(0)
  for (i in seq_along(items)) {
    if (items[[i]]$itemtype==2) ck<-c(ck,items[[i]]$ck)
    else if (items[[i]]$itemtype==3) ck<-c(ck,items[[i]]$ck[-1])
  }
  ck
}
