tccCompare<-function(itemsa,scoresa,itemsb,scoresb,xpoints,mainprepend=""){
  laba <- gsub("[[:punct:]]","",deparse(substitute(itemsa)))
  labb <- gsub("[[:punct:]]","",deparse(substitute(itemsb)))
  cairo_pdf(paste(mainprepend,laba,"-VS-",labb,".pdf",sep=""),family="MingLiu")
  par(mfrow=c(2,1))
  tccitemsa<-tcc(itemsa,scoresa,xpoints)
  tccitemsb<-tcc(itemsb,scoresb,xpoints)
  plot(xpoints,tccitemsa,type="l",xlab="theta",ylab="TCC",main=paste(mainprepend,laba,"-VS-",labb,sep=""))
  lines(xpoints,tccitemsb,lty="dotted")
  legend(2,50,c(paste("solid:",laba,sep=""),paste("dotted:",labb,sep="")))
  plot(xpoints,tccitemsb-tccitemsa,type="l",xlab="theta",ylab=paste("TCC ",labb,"-",laba,sep=""))
  abline(a=0,b=0)
  dev.off()
}
