plot.gpc<-function(obj,xrange,npoints,...) {
  pre<-pdf.gpc(obj,xrange,npoints)
  plot(0,0,type='n',xlim=xrange,ylim=c(0,1),main="category CC",xlab=pre$xlb,ylab="Prob")
  for (i in 1:obj$ncat) addlinewithlabel(pre$x,pre$y[,i],as.character(i))
}
