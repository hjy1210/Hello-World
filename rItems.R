rItems<-function(items,thetas){
# items: list of uirt item
# thetas 代表學生能力向量
# return category random matrix with items(columns),latent thetas(rows)
# 第i,j元素代表學生i在items[[j]]的反應類別
  rItem<-function(item,thetas){
  # item: an uirt item
  # thetas 代表學生能力向量
  # return category random variable with item,latent thetas
  # 第i元素代表學生i在item 的反應類別
  if (item$itemtype==3 || item$itemtype==2 || item$itemtype==1)
      prob<-item$pdf(thetas)
  else stop("only implement 3PL, gr and gpc")
  apply(prob,1,function(x) {
      s<-cumsum(x)
      rnd<-runif(1)
      for (i in 1:(item$ncat-1)) if (rnd<s[i]) return(i-1)
      return(item$ncat-1)
      })
  }
  sapply(items,rItem,thetas)
}
