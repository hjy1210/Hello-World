str<-c("A","B")
paste(str,1:2,sep="")
#[1] "A1" "B2"
paste(paste(str,1:2,sep=""),collapse="\t")
#[1] "A1\tB2"
