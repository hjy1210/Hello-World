readProItems<-function(file) {
  lns<-read.table(file,header=FALSE,sep="\n",colClasses="character")
  lns<-lns[[1]]
  prms<-list()
  for (i in 1:length(lns)) {
    prms[[i]]<-readProItem(lns[i])
  }
  prms
}
