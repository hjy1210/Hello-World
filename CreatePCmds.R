CreateProCmds<-function(ProjName,Filename,VNames,Models,Ks){
  Equals<-c()
  Fixes<-c()
  Anchors<-c()
  Cmds<-c()
  Leading<-c(paste("Project:","Name=",ProjName,";",sep=""))
  Leading<-c(Leading,paste("Data:","File=",Filename,";",sep=""))
  DumpCmds<-function(file) {
    MergeCmds()
    res<-c()
    for (i in seq_along(Leading)) {
      s<-Leading[i]
      s<-gsub("(:|;)","\\1\n\t",s)
      s<-gsub("="," = ",s)
      res<-c(res,s)
    }
    lines<-c()
    for (i in seq_along(res)){
      tokens<-strsplit(res[i],"\n")[[1]]
      for (j in seq_along(tokens)){
        if (length(tokens[j])>0 && tokens[j]!="\t") {
          if (substr(tokens[j],nchar(tokens[j]),nchar(tokens[j]))==";" && substr(tokens[j],1,1)!="\t")
            lines<-c(lines,paste("\t",tokens[j],sep=""))
          else
            lines<-c(lines,tokens[j])
        }  
      }
    }
    writeLines(lines,file)
  }
  MergeCmds<-function(){
    Constraints<-c(Equals,Fixes,Anchors)
    commands<-c(Cmds)
    if (length(Constraints)>0) commands<-c(commands,"Constraints:",Constraints)
    Leading<<-c(Leading,commands)
    Equals<<-c()
    Fixes<<-c()
    Anchors<<-c()
    Cmds<<-c()
  }
  AnalysisCmd<-function(Name,Mode="Calibration"){
    MergeCmds()
    Cmds<<-c(Cmds,c(paste("Analysis:","Name=",Name,";","Mode=",Mode,";",sep="")))
  }
  TitleCmd<-function(Title=""){
    Cmds<<-c(Cmds,c(paste("Title:",Title,sep="")))
  }
  CommentsCmd<-function(Comments=""){
    Cmds<<-c(Cmds,c(paste("Comments:",Comments,sep="")))
  }
  EstimationCmd<-function(Method="BAEM",EStepIter=500,EStepTol=1e-005,SE="S-EM",MStepIter=50,MStepTol=1e-006,QuadratureNodes=49,QuadratureMax=6,
                          SEM=0.001,SS=1e-005){
    Cmds<<-c(Cmds,c(paste("Estimation:","Method=",Method,";","E-Step=",EStepIter,", ",EStepTol,";","SE=",SE,";","M-Step=",MStepIter,", ",MStepTol,";",
          "Quadrature=",QuadratureNodes,", ",QuadratureMax,";","SEM=",SEM,";","SS=",SS,";",sep="")))
  }
  SaveCmd<-function(Save=c("PRM")){
    Cmds<<-c(Cmds,c(paste("Save:",paste(Save,collapse=", "),sep="")))
  }
  MiscCmd<-function(Decimal=4,Processor=8,Print=c("M2"),MinExp=1) {
    tmp<-paste("Miscellaneous:","Decimal=",Decimal,";","Processors=",Processor,";","Print ",paste(Print,collapse=", "),";",sep="")
    if (sum(Print=="GOF")>0) tmp<-paste(tmp,"Min Exp=",MinExp,";",sep="")
    Cmds<<-c(Cmds,tmp)
  }
  GroupCmd<-function(items,Mean,Covariance) {
    tmp<-paste("Dimension=1;","Items=",paste(VNames[items], collapse=", "),";",sep="")
    for (i in seq_along(items)) {
      tmp<-paste(tmp,"Codes(",VNames[items[i]],")=",paste(paste(1:Ks[items[i]]-1,"(",1:Ks[items[i]]-1,")",sep=""),collapse=", "),";",sep="")
    }
    for (i in seq_along(items)) {
      tmp<-paste(tmp,"Model(",VNames[items[i]],")=",Models[items[i]],";",sep="")
    }
    tmp<-paste(tmp,"Mean=",Mean,";",sep="")
    tmp<-paste(tmp,"Covariance=",Covariance,";",sep="")
    Cmds<<-c(Cmds,tmp)
  }
  GroupsCmd<-function(GroupVar=NULL,Groups=NULL, Items, Means=0.0, Covariances=1.0) {
    tmp<-c()
    if (is.null(GroupVar)) {
      Cmds<<-c(Cmds,"Groups:\nGroup:")
      GroupCmd(Items[[1]],Mean=Means[1],Covariance=Covariances[1])
    }
    else {
      Cmds<<-c(Cmds,paste("Groups:","Variable=",GroupVar,";\n",sep=""));
      for (i in seq_along(Groups)) {
        tmp<-paste("Group G",i,":",sep="")
        tmp<-paste(tmp,"Value=(",Groups[i],");",sep="")
        Cmds<<-c(Cmds,tmp)
        GroupCmd(Items[[i]],Mean=Means[i],Covariance=Covariances[i])
      }
    }
  }
  EqualparCmd<-function(Groups,items,types){
    type2str<-function(type) {
      if (type=="a") "Slope[0]"
      else if (type=="b") "Intercept[0]"
      else stop("Only implement for a,b with b single")
    }
    for (i in seq_along(types)){
      for (j in seq_along(items)){
        tmp<-"Equal="
        for (k in seq_along(Groups)){
          tmp<-paste(tmp,"(G",Groups[k],", ",VNames[items[j]],", ",type2str(types[i]),")",sep="")
          if (k<length(Groups)) tmp<-paste(tmp,", ",sep="")
          else tmp<-paste(tmp,";",sep="")
        }
        Equals<<-c(Equals,tmp)
      }
    }
  }
  EqualvarCmd<-function(Groups){
    tmp<-"Equal="
    for (k in seq_along(Groups)){
      tmp<-paste(tmp,"(G",Groups[k],", Covariance[0])",sep="")
      if (k<length(Groups)) 
        tmp<-paste(tmp,", ",sep="")
      else 
        tmp<-paste(tmp,";",sep="")
    }
    Equals<<-c(Equals,tmp)
  }
  FixaCmd<-function(PrependGroupWithComma, items, a) {
    tmp<-""
    for (i in seq_along(items)) {
      if (!is.na(a)) tmp<-paste(tmp,"(",PrependGroupWithComma,VNames[items[i]],", ","Slope[0])=",a,";",sep="")
    }
    if(length(tmp)>0) Fixes<<-c(Fixes,tmp)
  }
  FixasCmd<-function(Groups=NULL,Items,as){
    if (is.null(Groups)){
      FixaCmd("",items=Items[[1]],a=as[1])
    }
    else {
      for (i in seq_along(Groups)) {
        FixaCmd(paste("G",Groups[i],", ",sep=""),Items[[i]],a=as[i])
      }
    }
  }
  AnchorCmd<-function(PrependGroupWithComma, items, anchors){
    tmp<-""
    for (i in seq_along(items)) {
      tmp<-paste(tmp,"(",PrependGroupWithComma,VNames[items[i]],", ","Slope[0])=",anchors[[i]]$a,";",sep="")
      if (anchors[[i]]$itemtype==3)
        ck<-anchors[[i]]$ck[-1]
      else
        ck<-anchors[[i]]$ck
      for (j in seq_along(ck))
        tmp<-paste(tmp,"(",PrependGroupWithComma,VNames[items[i]],", ","Intercept[",j-1,"])=",ck[j],";",sep="")
    }
    Anchors<<-c(Anchors,tmp)
    
  }
  AnchorsCmd<-function(Groups=NULL,Items,listItems){
    if (is.null(Groups)){
      AnchorCmd("",items=Items[[1]],anchors=listItems[[1]])
    }
    else {
      for (i in seq_along(Groups)) {
        AnchorCmd(paste("G",Groups[i],", ",sep=""),Items[[i]],anchors=listItems[[i]])
      }
    }
  }
  list(AnalysisCmd=AnalysisCmd,TitleCmd=TitleCmd,
       CommentsCmd=CommentsCmd,EstimationCmd=EstimationCmd,SaveCmd=SaveCmd,MiscCmd=MiscCmd,
       GroupsCmd=GroupsCmd,FixasCmd=FixasCmd,DumpCmds=DumpCmds,EqualparCmd=EqualparCmd,
       EqualvarCmd=EqualvarCmd, AnchorsCmd=AnchorsCmd)
}
CreatePCmds<-function(ProjName,VNames,Models,Ks){
  SaveCmds<-function(file, commands) {
    res<-c()
    for (i in seq_along(commands)) {
      s<-commands[i]
      s<-gsub("(:|;)","\\1\n\t",s)
      s<-gsub("="," = ",s)
      res<-c(res,s)
    }
    writeLines(res,file)
  }
  ProjectCmd<-function(){
    paste("Project:","Name=",ProjName,";",sep="")
  }
  DataCmd<-function(Filename){
    paste("Data:","File=",Filename,";",sep="")
  }
  AnalysisCmd<-function(Name,Mode="Calibration"){
    paste("Analysis:","Name=",Name,";","Mode=",Mode,";",sep="")
  }
  TitleCmd<-function(Title=""){
    paste("Title:",Title,sep="")
  }
  CommentsCmd<-function(Comments=""){
    paste("Comments:",Comments,sep="")
  }
  EstimationCmd<-function(Method="BAEM",EStepIter=500,EStepTol=1e-005,SE="S-EM",MStepIter=50,MStepTol=1e-006,QuadratureNodes=49,QuadratureMax=6,
                          SEM=0.001,SS=1e-005){
    paste("Estimation:","Method=",Method,";","E-Step=",EStepIter,", ",EStepTol,";","SE=",SE,";","M-Step=",MStepIter,", ",MStepTol,";",
          "Quadrature=",QuadratureNodes,", ",QuadratureMax,";","SEM=",SEM,";","SS=",SS,";",sep="")
  }
  SaveCmd<-function(Save=c("PRM")){
    paste("Save:",paste(Save,collapse=", "),sep="")
  }
  MiscCmd<-function(Decimal=4,Processor=8,Print=c("M2"),MinExp=1) {
    tmp<-paste("Miscellaneous:","Decimal=",Decimal,";","Processors=",Processor,";","Print ",paste(Print,collapse=", "),";",sep="")
    if (sum(Print=="GOF")>0) tmp<-paste(tmp,"Min Exp=",MinExp,";",sep="")
    tmp
  }
  GroupCmd<-function(items,Mean,Covariance) {
    tmp<-paste("Dimension=1;","Items=",paste(VNames[items], collapse=", "),";",sep="")
    for (i in seq_along(items)) {
      tmp<-paste(tmp,"Codes(",VNames[items[i]],")=",paste(paste(1:Ks[items[i]]-1,"(",1:Ks[items[i]]-1,")",sep=""),collapse=", "),";",sep="")
    }
    for (i in seq_along(items)) {
      tmp<-paste(tmp,"Model(",VNames[items[i]],")=",Models[items[i]],";",sep="")
    }
    tmp<-paste(tmp,"Mean=",Mean,";",sep="")
    tmp<-paste(tmp,"Covariance=",Covariance,";",sep="")
    tmp
  }
  GroupsCmd<-function(GroupVar=NULL,Groups=NULL, Items, Means=0.0, Covariances=1.0) {
    tmp<-c()
    if (is.null(GroupVar)) {
      tmp<-"Groups:\nGroup:"
      tmp<-paste(tmp,GroupCmd(Items[[1]],Mean=Means[1],Covariance=Covariances[1]),sep="")
      tmp
    }
    else {
      tmp<-paste("Groups:","Variable=",GroupVar,";\n",sep="");
      for (i in seq_along(Groups)) {
        tmp<-paste(tmp,"Group G",i,":",sep="")
        tmp<-paste(tmp,"Value=(",Groups[i],");",sep="")
        tmp<-paste(tmp,GroupCmd(Items[[i]],Mean=Means[i],Covariance=Covariances[i]),"\n",sep="")
      }
      tmp
    }
  }
  EqualparCmd<-function(Groups,items,types){
    type2str<-function(type) {
      if (type=="a") "Slope[0]"
      else if (type=="b") "Intercept[0]"
      else stop("Only implement for a,b with b single")
    }
    tmp<-c()
    for (i in seq_along(types)){
      for (j in seq_along(items)){
        tmp<-paste(tmp,"Equal=",sep="")
        for (k in seq_along(Groups)){
           tmp<-paste(tmp,"(G",Groups[k],", ",VNames[items[j]],", ",type2str(types[i]),")",sep="")
           if (k<length(Groups)) tmp<-paste(tmp,", ",sep="")
           else tmp<-paste(tmp,";",sep="")
        }
      }
    }
    tmp
  }
  EqualvarCmd<-function(Groups){
    tmp<-"Equal="
    for (k in seq_along(Groups)){
      tmp<-paste(tmp,"(G",Groups[k],", Covariance[0])",sep="")
      if (k<length(Groups)) 
        tmp<-paste(tmp,", ",sep="")
      else 
        tmp<-paste(tmp,";",sep="")
    }
    tmp
  }
  FixaCmd<-function(PrependGroupWithComma, items, a) {
    tmp<-""
    for (i in seq_along(items)) {
      if (!is.na(a)) tmp<-paste(tmp,"(",PrependGroupWithComma,VNames[items[i]],", ","Slope[0])=",a,";",sep="")
    }
    tmp
  }
  FixasCmd<-function(Groups=NULL,Items,as){
    if (is.null(Groups)){
      FixaCmd("",items=Items[[1]],a=as[1])
    }
    else {
      tmp<-""
      for (i in seq_along(Groups)) {
        tmp<-paste(tmp,FixaCmd(paste("G",Groups[i],", ",sep=""),Items[[i]],a=as[i]),sep="")
      }
      tmp
    }
  }
  AnchorCmd<-function(PrependGroupWithComma, items, anchors){
    tmp<-""
    for (i in seq_along(items)) {
      tmp<-paste(tmp,"(",PrependGroupWithComma,VNames[items[i]],", ","Slope[0])=",anchors[[i]]$a,";",sep="")
      if (anchors[[i]]$itemtype==3)
        ck<-anchors[[i]]$ck[-1]
      else
        ck<-anchors[[i]]$ck
      for (j in seq_along(ck))
        tmp<-paste(tmp,"(",PrependGroupWithComma,VNames[items[i]],", ","Intercept[",j-1,"])=",ck[j],";",sep="")
    }
    tmp
    
  }
  AnchorsCmd<-function(Groups=NULL,Items,listItems){
    if (is.null(Groups)){
      AnchorCmd("",items=Items[[1]],anchors=listItems[[1]])
    }
    else {
      tmp<-""
      for (i in seq_along(Groups)) {
        tmp<-paste(tmp,AnchorCmd(paste("G",Groups[i],", ",sep=""),Items[[i]],anchors=listItems[[i]]),sep="")
      }
      tmp
    }
  }
  list(ProjectCmd=ProjectCmd,DataCmd=DataCmd,AnalysisCmd=AnalysisCmd,TitleCmd=TitleCmd,
       CommentsCmd=CommentsCmd,EstimationCmd=EstimationCmd,SaveCmd=SaveCmd,MiscCmd=MiscCmd,
       GroupsCmd=GroupsCmd,FixasCmd=FixasCmd,SaveCmds=SaveCmds,EqualparCmd=EqualparCmd,
       EqualvarCmd=EqualvarCmd, AnchorsCmd=AnchorsCmd)
}
CreatePCmds0<-function(ProjName,PrepV="VAR",Models,Ks){
  SaveCmds<-function(file, commands) {
    res<-c()
    for (i in seq_along(commands)) {
      s<-commands[i]
      s<-gsub("(:|;)","\\1\n\t",s)
      s<-gsub("="," = ",s)
      res<-c(res,s)
    }
    writeLines(res,file)
  }
  ProjectCmd<-function(){
    paste("Project:","Name=",ProjName,";",sep="")
  }
  DataCmd<-function(Filename){
    paste("Data:","File=",Filename,";",sep="")
  }
  AnalysisCmd<-function(Name,Mode="Calibration"){
    paste("Analysis:","Name=",Name,";","Mode=",Mode,";",sep="")
  }
  TitleCmd<-function(Title=""){
    paste("Title:",Title,sep="")
  }
  CommentsCmd<-function(Comments=""){
    paste("Comments:",Comments,sep="")
  }
  EstimationCmd<-function(Method="BAEM",EStepIter=500,EStepTol=1e-005,SE="S-EM",MStepIter=50,MStepTol=1e-009,QuadratureNodes=49,QuadratureMax=6,
                          SEM=0.001,SS=1e-005){
    paste("Estimation:","Method=",Method,";","E-Step=",EStepIter,", ",EStepTol,";","SE=",SE,";","M-Step=",MStepIter,", ",MStepTol,";",
          "Quadrature=",QuadratureNodes,", ",QuadratureMax,";","SEM=",SEM,";","SS=",SS,";",sep="")
  }
  SaveCmd<-function(Save=c("PRM")){
    paste("Save:",paste(Save,collapse=", "),sep="")
  }
  MiscCmd<-function(Decimal=4,Processor=8,Print=c("M2"),MinExp=1) {
    tmp<-paste("Miscellaneous:","Decimal=",Decimal,";","Processors=",Processor,";","Print ",paste(Print,collapse=", "),";",sep="")
    if (sum(Print=="GOF")>0) tmp<-paste(tmp,"Min Exp=",MinExp,";",sep="")
    tmp
  }
  GroupCmd<-function(items,Mean,Covariance) {
    tmp<-paste("Dimension=1;","Items=",paste(paste(PrepV,items,sep=""), collapse=", "),";",sep="")
    for (i in seq_along(items)) {
      tmp<-paste(tmp,"Codes(",PrepV,items[i],")=",paste(paste(1:Ks[items[i]]-1,"(",1:Ks[items[i]]-1,")",sep=""),collapse=", "),";",sep="")
    }
    for (i in seq_along(items)) {
      tmp<-paste(tmp,"Model(",PrepV,items[i],")=",Models[items[i]],";",sep="")
    }
    tmp<-paste(tmp,"Mean=",Mean,";",sep="")
    tmp<-paste(tmp,"Covariance=",Covariance,";",sep="")
    tmp
  }
  GroupsCmd<-function(GroupVarIndex=NULL,Groups=NULL, Items, Means=0.0, Covariances=1.0) {
    tmp<-c()
    if (is.null(GroupVarIndex)) {
      tmp<-"Groups:\nGroup:"
      tmp<-paste(tmp,GroupCmd(Items[[1]],Mean=Means[1],Covariance=Covariances[1]),sep="")
      tmp
    }
    else {
      tmp<-paste("Groups:","Variable=",PrepV,GroupVarIndex,";\n",sep="");
      for (i in seq_along(Groups)) {
        tmp<-paste(tmp,"Group G",i,":",sep="")
        tmp<-paste(tmp,"Value=(",Groups[i],");",sep="")
        tmp<-paste(tmp,GroupCmd(Items[[i]],Mean=Means[i],Covariance=Covariances[i]),"\n",sep="")
      }
      tmp
    }
  }
  EqualparCmd<-function(Groups,items,types){
    type2str<-function(type) {
      if (type=="a") "Slope[0]"
      else if (type=="b") "Intercept[0]"
      else stop("Only implement for a,b with b single")
    }
    tmp<-c()
    for (i in seq_along(types)){
      for (j in seq_along(items)){
        tmp<-paste(tmp,"Equal=",sep="")
        for (k in seq_along(Groups)){
          tmp<-paste(tmp,"(G",Groups[k],", ",PrepV,items[j],", ",type2str(types[i]),")",sep="")
          if (k<length(Groups)) tmp<-paste(tmp,", ",sep="")
          else tmp<-paste(tmp,";",sep="")
        }
      }
    }
    tmp
  }
  FixaCmd<-function(PrependGroupWithComma, items, a) {
    tmp<-""
    for (i in seq_along(items)) {
      if (!is.na(a)) tmp<-paste(tmp,"(",PrependGroupWithComma,PrepV,items[i],", ","Slope[0])=",a,";",sep="")
    }
    tmp
  }
  FixasCmd<-function(Groups=NULL,Items,as){
    if (is.null(Groups)){
      FixaCmd("",items=Items[[1]],a=as[1])
    }
    else {
      tmp<-""
      for (i in seq_along(Groups)) {
        tmp<-paste(tmp,FixaCmd(paste("G",Groups[i],", ",sep=""),Items[[i]],a=as[i]),sep="")
      }
      tmp
    }
  }
  AnchorCmd<-function(PrependGroupWithComma, items, anchors){
    tmp<-""
    for (i in seq_along(items)) {
      tmp<-paste(tmp,"(",PrependGroupWithComma,PrepV,items[i],", ","Slope[0])=",anchors[[i]]$a,";",sep="")
      if (anchors[[i]]$itemtype==3)
        ck<-anchors[[i]]$ck[-1]
      else
        ck<-anchors[[i]]$ck
      for (j in seq_along(ck))
        tmp<-paste(tmp,"(",PrependGroupWithComma,PrepV,items[i],", ","Intercept[",j-1,"])=",ck[j],";",sep="")
    }
    tmp
    
  }
  AnchorsCmd<-function(Groups=NULL,Items,lstItems){
    if (is.null(Groups)){
      AnchorCmd("",items=Items[[1]],anchors=lstItems[[1]])
    }
    else {
      tmp<-""
      for (i in seq_along(Groups)) {
        tmp<-paste(tmp,AnchorCmd(paste("G",Groups[i],", ",sep=""),Items[[i]],anchor=lstItems[[i]]),sep="")
      }
      tmp
    }
  }
  list(ProjectCmd=ProjectCmd,DataCmd=DataCmd,AnalysisCmd=AnalysisCmd,TitleCmd=TitleCmd,
       CommentsCmd=CommentsCmd,EstimationCmd=EstimationCmd,SaveCmd=SaveCmd,MiscCmd=MiscCmd,
       GroupsCmd=GroupsCmd,FixasCmd=FixasCmd,SaveCmds=SaveCmds,EqualparCmd=EqualparCmd,AnchorsCmd=AnchorsCmd)
}
