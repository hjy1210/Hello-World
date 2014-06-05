readProItem<-function(s){
  tokens<-strsplit(s,c('\t'))[[1]]
  name<-tokens[1]
  values<-as.numeric(tokens[2:length(tokens)])
  nfac<-values[1]
  itemtype<-values[2]
  if (itemtype==3){   # 3:nominal
    # name nfac itemtype ncat gpc a(nfac) aType alpha(ncat-1) cType g(ncat-1) ak(ncat) ck(ncat) b dk(ncat)
    m<-values[3]
    ncat<-m
    gpc<-values[4]
    ndx<-5
    a<-values[ndx:(ndx+nfac-1)]
    ndx<-ndx+nfac
    aType<-values[ndx]
    ndx<-ndx+1
    alpha<-values[ndx:(ndx+m-2)]
    ndx<-ndx+m-1
    if (aType==0)
      as <- TF(m) %*% alpha
    else if (aType==1)
      as <- TI(m) %*% alpha
    ak<-a*as
    cType<-values[ndx]
    ndx<-ndx+1
    g<-values[ndx:(ndx+m-2)]
    ndx<-ndx+m-1
    ck<-NA
    if (cType==0)
      ck <- TF(m) %*% g
    else if (cType==1)
      ck <- TI(m) %*% g
    if (nfac==1) {
      ak1<-values[ndx:(ndx+m-1)]
      ndx<-ndx+m
      ck1<-values[ndx:(ndx+m-1)]
      ndx<-ndx+m
      b<- values[ndx] # len=1
      ndx<-ndx+1
      dk<-values[ndx:(ndx+m-1)] # len=ncat
      bk<-c(0,solve(TcPC(m)[-1,],ck[-1])/a) # len=ncat
      consistency<-max(c(abs(b-mean(bk[-1])),abs(b-bk[-1]-dk[-1]),abs(ak-ak1),abs(ck-ck1)))
    }
    res<-list(name=name,nfac=nfac,itemtype=itemtype,ncat=m,gpc=gpc,astar=a,as=c(as),ak=a*c(as),ck=c(ck),b=b,dk=dk,ck1=ck1,ak1=ak1,
              bk=bk,consistency=consistency)
    class(res)<-"uirt"
    res
  }
  else if (itemtype==2){
    m<-values[3]
    ndx<-4
    a<-values[ndx:(ndx+nfac-1)]
    ndx<-ndx+nfac
    ck<-values[ndx:(ndx+m-2)]
    ndx<-ndx+m-1
    if (nfac==1) {
      bk<-values[ndx:(ndx+m-2)]
      ndx<-ndx+m-1
      consistency<-max(-ck/a-bk)
    }
    res<-list(name=name,nfac=nfac,itemtype=itemtype,ncat=m,a=a,ck=ck,bk=bk,consistency=consistency)
    class(res)<-"uirt"
    res
  }
  else if (itemtype==0) {
    mu<-numeric(nfac)
    ndx<-3
    mu<-values[ndx:(ndx+nfac-1)]
    ndx<-ndx+nfac
    n<-nfac*(nfac+1)/2
    lowercov<-values[ndx:(ndx+n-1)]
    ndx<-ndx+n
    res<-list(name=name,nfac=nfac,itemtype=itemtype,mu=mu,lowercov=lowercov)
    class(res)<-"pop"
    res
  }
}
