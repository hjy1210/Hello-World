plotuirt<-function(itema,xpoints,itemb=NA,prep=c("",""),...){
  clsnamea<-class(itema)
  clsnameb<-class(itemb)
  if (clsnamea != "uirt" ) stop(" only implement for class uirt")
  if (clsnameb!="uirt" && clsnameb!="logical") stop(" only implement for class uirt")
  pdfa<-itema$pdf(xpoints)
  if (clsnameb=="uirt") {
    pdfb<-itemb$pdf(xpoints)
  }
  xlb<-paste(prep[1],itema$name," a=",round(itema$a,digits=2),sep="")
  bk1<-round(itema$bk,digits=2)
  xlb<-paste(xlb," b=",paste(bk1,collapse=","),sep="")
  if (clsnameb=="uirt") {
    xlb2<-paste(prep[2],itemb$name," a=",round(itemb$a,digits=2),sep="")
    bk2<-round(itemb$bk,digits=2)
    xlb<-paste("(solid)",xlb,"\n","(dotted)",xlb2," b=",paste(bk2,collapse=","),sep="")
  }
  plot(0,0,type='n',xlim=c(min(xpoints),max(xpoints)),ylim=c(0,1),xlab=xlb,ylab="Prob",...)
  for (i in 1:itema$ncat) {
    addlinewithlabel(xpoints,pdfa[,i],as.character(i),lty=1)
  }
  if (clsnameb=="uirt") {
    for (i in 1:itemb$ncat) {
      addlinewithlabel(xpoints,pdfb[,i],as.character(i),lty=3,col="red")
    }
  }
}
