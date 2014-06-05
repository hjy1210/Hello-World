rItem<-function(item,thetas){
# item: an uirt item
# thetas 代表學生能力向量
# return category random variable with item,latent thetas
# 第i元素代表學生i在item 的反應類別
  if (item$itemtype==3)
    prob<-pdf.gpc(item,thetas)
  else if (item$itemtype==2)
    prob<-pdf.gr(item,thetas)
  else stop("only implement gr and gpc")
  apply(prob,1,function(x) {
        s<-cumsum(x)
  	 rnd<-runif(1)
  	 for (i in 1:(item$ncat-1)) if (rnd<s[i]) return(i-1)
  	 return(item$ncat-1)
        })
  #print(prob)
  #res<-c()
  #for (i in 1:dim(prob)[1]) {
  #  rnd<-runif(1)
  #  s<-cumsum(prob[i,])
  #  #print(item$ncat)
  #  print(rnd)
  #  print(s)
  #  for (j in 1:item$ncat) {
  #    if (j<item$ncat && rnd<s[j]) {
  #      res<-c(res,j-1)
  #	break
  #    }
  #    else if (j==item$ncat)
  #      res<-c(res,item$ncat-1)
  #  }
  #}
  #res
}
