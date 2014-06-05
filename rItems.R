rItems<-function(items,thetas){
# items: list of uirt item
# thetas 代表學生能力向量
# return category random matrix with items(columns),latent thetas(rows)
# 第i,j元素代表學生i在items[[j]]的反應類別
  sapply(items,rItem,thetas)
}
