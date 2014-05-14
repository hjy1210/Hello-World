tccCompare<-function(itemsa,scoresa,itemsb,scoresb,xrange,npoints,laba,labb,mainprepend=""){
  cairo_pdf(paste(mainprepend,laba,"-VS-",labb,".pdf",sep=""),family="MingLiu")
  par(mfrow=c(2,1))
  tccitemsa<-tcc(itemsa,scoresa,xrange,npoints)
  tccitemsb<-tcc(itemsb,scoresb,xrange,npoints)
  plot(tccitemsa$x,tccitemsa$y,type="l",xlab="theta",ylab="TCC",main=paste(mainprepend,laba,"-VS-",labb,sep=""))
  lines(tccitemsb$x,tccitemsb$y,lty="dotted")
  legend(2,50,c(paste("solid:",laba,sep=""),paste("dotted:",labb,sep="")))
  plot(tccitemsa$x,tccitemsb$y-tccitemsa$y,type="l",xlab="theta",ylab=paste("TCC ",labb,"-",laba,sep=""))
  abline(a=0,b=0)
  dev.off()
}
