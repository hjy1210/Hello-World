plot.uirt<-function(itema,xrange,npoints,itemb=NA,prepend=c("","")){
  clsnamea<-class(itema)
  clsnameb<-class(itemb)
  if (clsnamea != "uirt" ) stop(" only implement for class uirt")
  if (clsnameb!="uirt" && clsnameb!="logical") stop(" only implement for class uirt")
  if (itema$itemtype==3) {
    prea<-pdf.gpc(itema,xrange,npoints,prepend=prepend[1])
  }
  else if(itema$itemtype==2) {
    prea<-pdf.gr(itema,xrange,npoints,prepend=prepend[1])
  }
  if (clsnameb=="uirt") {
    if (itemb$itemtype==3)
    {
      preb<-pdf.gpc(itemb,xrange,npoints,prepend=prepend[2])
    }
    else if (itemb$itemtype==2) {
      preb<-pdf.gr(itemb,xrange,npoints,prepend=prepend[2])
    }
  }
  xlb=prea$xlb
  if (clsnameb=="uirt") xlb<-paste("(solid)",xlb,"\n","(dotted)",preb$xlb,sep="")
  plot(0,0,type='n',xlim=xrange,ylim=c(0,1),main="compare category CC",xlab=xlb,ylab="Prob")
  for (i in 1:itema$ncat) {
    addlinewithlabel(prea$x,prea$y[,i],as.character(i),lty=1)
  }
  if (clsnameb=="uirt") {
    for (i in 1:itemb$ncat) {
      addlinewithlabel(preb$x,preb$y[,i],as.character(i),lty=3,col="red")
    }
  }
}
