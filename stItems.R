stItems<-function(listItem,anchorNew,anchorOld) {
  shiftAmount<-mean(getBks(anchorOld))-mean(getBks(anchorNew))
  shiftItems(listItem,shiftAmount)
}
