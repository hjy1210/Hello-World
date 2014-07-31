bksCompare<-function(itemsa,itemsb,pdf=FALSE,shift=TRUE) {
  namea <- gsub("[[:punct:]]","",deparse(substitute(itemsa)))
  nameb <- gsub("[[:punct:]]","",deparse(substitute(itemsb)))
  forma<-getBks(itemsa)  #forma are bks extracted from itemsa
  formb<-getBks(itemsb)
  if (pdf==TRUE){
    cairo_pdf(paste(namea,"-",nameb,".pdf",sep=""))
  }
  else {
    png(paste(namea,"-",nameb,".png",sep=""),type="cairo")
  }
  par(mfrow=c(2,1))
  mdiff<-mean(formb)-mean(forma)
  if (shift==TRUE){
    a<-mean(formb)-mean(forma)
  }
  else {
    a<-0
  }
  plot(forma,formb,xlab=namea,ylab=nameb,main=paste("Correlation=",sprintf("%7.4f",cor(forma,formb)),"\n",paste("mean ",nameb,"- mean",namea,"=",sprintf("%7.4f",mdiff))))
  abline(a=a,b=1)
  if (shift==TRUE){
    plot(forma,formb-forma-(mean(formb)-mean(forma)),xlab=namea,ylab="difference after shift",main=paste("compare",namea,nameb))
  }
  else {
    plot(forma,formb-forma,xlab=namea,ylab="difference",main=paste("compare",namea,nameb))
  }
  abline(a=0,b=0)
  dev.off()
}
