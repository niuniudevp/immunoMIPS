#!/usr/bin/env Rscript
library(DiffBind)

mydat<-dba(sampleSheet="metadata.csv")
mydat<-dba.count(mydat,score="DBA_SCORE_READS")
print(mydat)
counts<-dba.peakset(mydat,bRetrieve=TRUE,DataType=DBA_DATA_FRAME)
write.table(counts,"readscores.raw.txt",sep="\t",row.names=TRUE)
