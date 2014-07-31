CreateProCmds<-function(ProjName,Filename,VNames){
  # Models, Ks change to parameters of Analysis
  Models<-NULL
  Ks<-NULL
  ListCodes<-NULL
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
  AnalysisCmd<-function(Name,Mode="Calibration",models,listCodes){
    MergeCmds()
    Cmds<<-c(Cmds,c(paste("Analysis:","Name=",Name,";","Mode=",Mode,";",sep="")))
    Models<<-models
    ListCodes<<-listCodes
    Ks<<-sapply(listCodes,length)
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
  getModel<-function(itemname,model) {
    tokens<-strsplit(model,",")[[1]]
    if (length(tokens)==3){
      paste(tokens[1],";AlphaMatrix(",itemname,")=",tokens[2],";GammaMatrix(",itemname,")=",tokens[3])
    }
    else if (length(tokens)==2)
      paste(tokens[1],";GammaMatrix(",itemname,")=",tokens[2])
    else
      model
  }
  GroupCmd<-function(items,Mean,Covariance) {
    tmp<-paste("Dimension=1;","Items=",paste(VNames[items], collapse=", "),";",sep="")
    for (i in seq_along(items)) {
      tmp<-paste(tmp,"Codes(",VNames[items[i]],")=",paste(paste(ListCodes[[items[i]]],"(",1:Ks[items[i]]-1,")",sep=""),collapse=", "),";",sep="")
    }
    for (i in seq_along(items)) {
      tmp<-paste(tmp,"Model(",VNames[items[i]],")=",getModel(VNames[items[i]],Models[items[i]]),";",sep="")
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
  EqualparCmd<-function(Groups,items,types,intraItems=FALSE){
    # 2014/06/28 新增intraItems參數
    # 2014/07/07 新增index
    type2str<-function(type,index=0) {
      if (type=="a") paste("Slope[",index,"]",sep="")
      else if (type=="b") paste("Intercept[",index,"]",sep="")
      else if (type=="gamma") paste("Gamma[",index,"]",sep="")
      else if (type=="lg") paste("Guessing[",index,"]",sep="")
      else stop("Only implement for a,b,gamma,lg")
    }
    if (intraItems==FALSE){
      for (i in seq_along(types)){
        for (j in seq_along(items)){
          indexes<-c(0)
          if (types[i]=="b" || types[i]=="gamma") indexes<-0:(Ks[items[j]]-2)
          for (index in indexes) {
            tmp<-"Equal="
            for (k in seq_along(Groups)){
              tmp<-paste(tmp,"(G",Groups[k],", ",VNames[items[j]],", ",type2str(types[i],index),")",sep="")
              if (k<length(Groups)) tmp<-paste(tmp,", ",sep="")
              else tmp<-paste(tmp,";",sep="")
            }
            Equals<<-c(Equals,tmp)
          }
        }
      }
    }  
    else {
      for (i in seq_along(types)){
         if (types[i]!="a") stop("When intraItems==TRUE, only implement for type==\"a\"")
         if (is.null(Groups) || is.na(Groups))
           pGroups<-"("
         else
           pGroups<-paste("(G",Groups,",",sep="")
         tmp<-"Equal="
         for (j in seq_along(items)){
           for (k in seq_along(pGroups)){
             tmp<-paste(tmp,pGroups[k],VNames[items[j]],", ",type2str(types[i]),")",sep="")
             if (j==length(items) && k==length(pGroups)) {
               tmp<-paste(tmp,";",sep="")
             }
             else {
               tmp<-paste(tmp,", ",sep="")
             }
           }
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
      if (anchors[[i]]$itemtype==3) {
        ck<-anchors[[i]]$ck[-1]
        model<-Models[items[i]]
        tokens<-strsplit(model,",")[[1]]
        if (tokens[2]=="Identity")
          mat<-TI(Ks[items[i]])[-1,]
        else
          mat<-TF(Ks[items[i]])[-1,]
        gk<- solve(mat,ck)
        for (j in seq_along(gk))
          tmp<-paste(tmp,"(",PrependGroupWithComma,VNames[items[i]],", ","Gamma[",j-1,"])=",gk[j],";",sep="")
      }
      else if (anchors[[i]]$itemtype==2){
        ck<-anchors[[i]]$ck
        for (j in seq_along(ck))
          tmp<-paste(tmp,"(",PrependGroupWithComma,VNames[items[i]],", ","Intercept[",j-1,"])=",ck[j],";",sep="")
      }
      else if (anchors[[i]]$itemtype==1){
        ck<-anchors[[i]]$ck
        for (j in seq_along(ck))
          tmp<-paste(tmp,"(",PrependGroupWithComma,VNames[items[i]],", ","Intercept[",j-1,"])=",ck[j],";",sep="")
        tmp<-paste(tmp,"(",PrependGroupWithComma,VNames[items[i]],", ","Guessing[",j-1,"])=",anchors[[i]]$lg,";",sep="")
     }
      else stop("AnchorCmd only support itemtype==1,2,3")
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
