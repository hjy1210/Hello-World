#  separated each character by '\t', replace characters match pattern with -1,
cqc2pro<-function(sourcefile,targetfile,cols,pattern="[ .]"){
    lines<-readLines(sourcefile)
    res<-substr(lines,cols[1],cols[1])
    for (i in 2:length(cols)) {
        res<-paste(res,substr(lines,cols[i],cols[i]),sep="\t")
    }
    res<-gsub(pattern,"-1",res)
    header<-paste(paste("VAR",1:length(cols),sep=""),collapse='\t')
    res<-c(header,res)
    writeLines(res,targetfile)
}
