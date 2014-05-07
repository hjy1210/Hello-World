addlinewithlabel<-function(x,y,label,lty=1,...) {
  ndx<-1
  mx<-y[1]
  #print(c(length(x),length(y)))
  for (i in 2:length(x)) {
    if (y[i]>mx) {
      mx<-y[i]
      ndx<-i
    }
  }
  lines(x,y,lty=lty,...)
  text(x[ndx],y[ndx],label,...)
}
