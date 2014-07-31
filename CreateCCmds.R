CreateCCmds<-function(datafile,GroupNames=NULL,Positions=NULL,responses,constraints="none",
                      fit="no",warnings="no",nodes=15,converge="0.0001",stderr="none",exportprmfile=NA,showfile=NA,Model="item",
                      importprmfile=NA){
  res<-c("reset;")
  res<-c(res,paste("Datafile ",datafile,";",sep=""))
  
  tmp<-"Format "
  if (!is.null(GroupNames)){
    for (i in seq_along(GroupNames)) {
      tmp<-paste(tmp, GroupNames[i]," ",Positions[i]," ",sep="")
    }
  }
  tmp<-paste(tmp,"responses ",responses,";",sep="")
  res<-c(res,tmp)
  
  if (!is.null(GroupNames)){
    tmp<-""
    for (i in seq_along(GroupNames)) {
      tmp<-paste(tmp,GroupNames[i]," ",sep="")
    }
    tmp<-paste("regression ",tmp,";",sep="")
    res<-c(res,tmp)
  }
  if (!is.na(importprmfile)){
    res<-c(res,paste("import anchor_parameters << ",importprmfile,";",sep=""))
  }
  
  
  res<-c(res,paste("set ","constraints=",constraints,", ","warnings=",warnings,";",sep=""))
  res<-c(res,paste("Model ",Model,";",sep=""))
  res<-c(res,paste("Estimate ! ","stderr=",stderr,", fit=",fit,", nodes=",nodes,", converge=",converge,";",sep=""))
  if (!is.na(exportprmfile)){
    res<-c(res,paste("export parameters >> ",exportprmfile,";",sep=""))
  }
  if (!is.na(showfile)){
    res<-c(res,paste("show >> ",showfile,";",sep=""))
  }
  res
}