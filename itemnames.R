itemnames<-function(items){
  #res<-c()
  #for (i in seq_along(items)) res<-c(res,items[[i]]$name)
  #res
  sapply(items,function(item) {item$name})
}
