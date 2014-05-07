str<-c("A","B")
paste(str,1:2,sep="")
#[1] "A1" "B2"
paste(paste(str,1:2,sep=""),collapse="\t")
#[1] "A1\tB2"

appendTabExceptLast<-function(v) {
   v[-1]<-paste("\t",v[-1],sep="")
   v
}

# each string in strings should be of the same length
insertTab<-function(strings) {
  t1<-sapply(strings,strsplit,split=NULL)
  names(t1)<-NULL
  t2<-sapply(t1,appendTabExceptLast)
  apply(t2,2,paste,collapse="")
}
insertTab(c("abcd"))
#[1] "a\tb\tc\td"
insertTab(c("abcd","1234"))
#[1] "a\tb\tc\td" "1\t2\t3\t4"

 