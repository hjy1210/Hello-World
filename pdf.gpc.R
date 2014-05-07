pdf.gpc<-function(obj,xrange,npoints,prepend="") {
  xpoints<-seq(xrange[1],xrange[2],len=npoints)
  ncat<-obj$ncat
  den<-1
  num<-matrix(0,nrow=length(xpoints),ncol=ncat)
  num[,1]<-1
  for (i in 2:ncat) {
    num[,i]<-exp(obj$ak[i]*xpoints+obj$ck[i])
    den<-den+num[,i]
  }
  for (i in 1:ncat) {
    num[,i]<-num[,i]/den
  }
  akstr<-"GPC ak="
  ckstr<-"-ck/ak= "
  for (i in 2:ncat) {
    akstr<-paste(akstr,obj$ak[i],sep="")
    ckstr<-paste(ckstr,-obj$ck[i]/obj$ak[i],sep="")
    if (i<ncat) {
      akstr<-paste(akstr,",",sep="")
      ckstr<-paste(ckstr,",",sep="")
    }    
  }
  list(x=xpoints,y=num,xlb=paste(prepend,obj$name,akstr,ckstr))
}
