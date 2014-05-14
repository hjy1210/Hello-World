# sequentially replace all character match pattern[i] with replacestr[i]
cqc2cqc<-function(sourcefile,targetfile,patterns=" ",replacestrs="."){
    lines<-readLines(sourcefile)
    for (i in 1:length(patterns)) {
        lines<-gsub(patterns[i],replacestrs[i],lines)
    }
    writeLines(lines,targetfile)
}
