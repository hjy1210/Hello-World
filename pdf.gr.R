pdf.gr<-function(obj,xrange,npoints,prepend="") {
  f<-function(k,thetas) {
    1/(1+exp(-obj$a*thetas-obj$ck[k]))
  }
  xpoints<-seq(xrange[1],xrange[2],len=npoints)
  ncat<-obj$ncat
  num<-matrix(0,nrow=length(xpoints),ncol=ncat)
  num[,1]<-1-f(1,xpoints)
  if (ncat>2) {
    for (i in 2:(ncat-1)) {
      num[,i]<-f(i-1,xpoints)-f(i,xpoints)
    }
  }
  num[,ncat]<-f(ncat-1,xpoints)
  akstr<-paste("GR a=",obj$a,sep="")
  ckstr<-"-ck/a= "
  for (i in 1:(ncat-1)) {
    ckstr<-paste(ckstr,-obj$ck[i]/obj$a,sep="")
    if (i<ncat-1) {
      ckstr<-paste(ckstr,",",sep="")
    }    
  }
  list(x=xpoints,y=num,xlb=paste(prepend,obj$name,akstr,ckstr))
}
