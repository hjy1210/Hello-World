compareCks<-function(forma,formb,labx,laby,pdf=FALSE,shift=TRUE) {
  if (pdf==TRUE){
    cairo_pdf(paste(labx,"-",laby,".pdf",sep=""))
  }
  else {
    png(paste(labx,"-",laby,".png",sep=""),type="cairo")
  }
  par(mfrow=c(2,1))
  mdiff<-mean(formb)-mean(forma)
  if (shift==TRUE){
    a<-mean(formb)-mean(forma)
  }
  else {
    a<-0
  }
  plot(forma,formb,xlab=labx,ylab=laby,main=paste("Correlation=",cor(forma,formb),"\n","mean difference=",mdiff))
  abline(a=a,b=1)
  if (shift==TRUE){
    plot(forma,formb-forma-(mean(formb)-mean(forma)),xlab=labx,ylab="difference after shift",main=paste("compare",labx,laby))
  }
  else {
    plot(forma,formb-forma,xlab=labx,ylab="difference",main=paste("compare",labx,laby))
  }
  abline(a=0,b=0)
  dev.off()
}
