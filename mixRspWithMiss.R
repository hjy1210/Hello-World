mixRspWithMiss<-function(responsestr,fulllength,startendsource,startendtarget){
  n<-length(responsestr)
  placeholder<-rep(paste(rep(".",fulllength),collapse=""),n)
  for (i in 1:dim(startendsource)[1]) 
    substr(placeholder,startendtarget[i,1],startendtarget[i,2])<-
      substr(responsestr,startendsource[i,1],startendsource[i,2]) 
  placeholder
}