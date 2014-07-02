readPItems<-function(lines,file=NULL){
    if (!is.null(file)) lines<-readLines(file)
    linetokens<-strsplit(lines,c("[[:space:]]+"))
    res<-list()
    length(res)<-length(linetokens)
    for (i in seq_along(linetokens)){
      tokens<-linetokens[[i]]
      name<-tokens[1]
      values<-as.numeric(tokens[2:length(tokens)])
      nfac<-values[1]
      itemtype<-values[2]
      if (itemtype==3){   # 3:nominal
        # name nfac itemtype ncat gpc a(nfac) aType alpha(ncat-1) cType g(ncat-1) ak(ncat) ck(ncat) b dk(ncat)
        ncat<-values[3]
        gpc<-values[4]
        ndx<-5
        a<-values[ndx:(ndx+nfac-1)]
        ndx<-ndx+nfac
        aType<-values[ndx]
        ndx<-ndx+1
        alpha<-values[ndx:(ndx+ncat-2)]
        ndx<-ndx+ncat-1
        if (aType==0)
          as <- TF(ncat) %*% alpha
        else if (aType==1)
          as <- TI(ncat) %*% alpha
        ak<-a*as
        cType<-values[ndx]
        ndx<-ndx+1
        g<-values[ndx:(ndx+ncat-2)]
        ndx<-ndx+ncat-1
        ck<-NA
        if (cType==0)
          ck <- TF(ncat) %*% g
        else if (cType==1)
          ck <- TI(ncat) %*% g
        if (nfac==1) {
          ak1<-values[ndx:(ndx+ncat-1)]
          ndx<-ndx+ncat
          ck1<-values[ndx:(ndx+ncat-1)]
          ndx<-ndx+ncat
          b<- values[ndx] # len=1
          ndx<-ndx+1
          dk<-values[ndx:(ndx+ncat-1)] # len=ncat
          bk<-c(0,solve(TcPC(ncat)[-1,],ck[-1])/a) # len=ncat
          res[[i]]<-Gpc(name=name,a=a,bk=bk[-1])
          res[[i]]$consistency<-max(c(abs(b-mean(bk[-1])),abs(b-bk[-1]-dk[-1]),abs(ak-ak1),abs(ck-ck1)))
        }
        else stop("only implement nfac=1")
      }
      else if (itemtype==2){
        ncat<-values[3]
        ndx<-4
        a<-values[ndx:(ndx+nfac-1)]
        ndx<-ndx+nfac
        ck<-values[ndx:(ndx+ncat-2)]
        ndx<-ndx+ncat-1
        if (nfac==1) {
          bk<-values[ndx:(ndx+ncat-2)]
          ndx<-ndx+ncat-1
          consistency<-max(-ck/a-bk)
          res[[i]]<-Gr(name=name,a=a,bk=bk)
          res[[i]]$consistency<-consistency
        }
        else stop("only implement nfac=1")
      }
      else if (itemtype==1){
        ncat<-values[3]
        a<-values[4]
        c<-values[5]
        lg<-values[6]
        res[[i]]<-PL(name=name,a=a,bk=-c/a,lg=lg)
      }
      else if (itemtype==0) {
        mu<-numeric(nfac)
        ndx<-3
        mu<-values[ndx:(ndx+nfac-1)]
        ndx<-ndx+nfac
        n<-nfac*(nfac+1)/2
        lowercov<-values[ndx:(ndx+n-1)]
        ndx<-ndx+n
        res[[i]]<-list(name=name,nfac=nfac,itemtype=itemtype,mu=mu,lowercov=lowercov)
        class(res[[i]])<-"pop"
      }
    }
    res
}
