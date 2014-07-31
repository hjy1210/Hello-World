shiftItems<-function(listItem,shiftAmount) {
  res<-list()
  length(res)<-length(listItem)
  for (i in seq_along(listItem)){
    if (listItem[[i]]$itemtype==1) 
      res[[i]]<-PL(name=listItem[[i]]$name,a=listItem[[i]]$a,bk=listItem[[i]]$bk+shiftAmount,lg=listItem[[i]]$lg)
    else if (listItem[[i]]$itemtype==2)
      res[[i]]<- Gr(name=listItem[[i]]$name,a=listItem[[i]]$a,bk=listItem[[i]]$bk+shiftAmount)
    else if (listItem[[i]]$itemtype==3)
      res[[i]]<-Gpc(name=listItem[[i]]$name,a=listItem[[i]]$a,bk=listItem[[i]]$bk+shiftAmount)
    else
      stop("shift adjust Only implement PL, Gr, Gpc")
  }
  res
}
