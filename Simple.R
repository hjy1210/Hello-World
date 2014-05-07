str<-c("A","B")
paste(str,1:2,sep="")
#[1] "A1" "B2"
paste(paste(str,1:2,sep=""),collapse="\t")
#[1] "A1\tB2"

appendTabExceptLast<-function(v) {
   v[-1]<-paste("\t",v[-1],sep="")
   v
}

insertTab<-function(s) {
  paste(appendTabExceptLast(strsplit(s,split=NULL)[[1]]),collapse="")
}
insertTab(c("abcd"))
#[1] "a\tb\tc\td"
 