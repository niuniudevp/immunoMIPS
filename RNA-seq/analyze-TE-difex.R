#!/usr/bin/Rscript
setwd("C:/CRISPR/immuno-MIPS/GQ-RNAseq/round1/TE-quant")
d1<-read.table("SampleMll21-TE.cntTable",sep="\t",header=TRUE,row.names=1)
d2<-read.table("SampleMll22-TE.cntTable",sep="\t",header=TRUE,row.names=1)
d3<-read.table("SampleMll23-TE.cntTable",sep="\t",header=TRUE,row.names=1)
d4<-read.table("SamplepSC071-TE.cntTable",sep="\t",header=TRUE,row.names=1)
d5<-read.table("SamplepSC072-TE.cntTable",sep="\t",header=TRUE,row.names=1)
d6<-read.table("SamplepSC073-TE.cntTable",sep="\t",header=TRUE,row.names=1)

data<-cbind(d1,d2,d3,d4,d5,d6)
colnames(data)<-c("Kmt2d_1","Kmt2d_2","Kmt2d_3","Vector_1","Vector_2","Vector_3")


library(DESeq2)
info<-read.table("sample-info.txt",sep="\t",header=TRUE,row.names=1)
dataf<-data[rowSums(data)>=10,]
all(rownames(info)==colnames(dataf))

dds<-DESeqDataSetFromMatrix(countData=dataf,colData=info,design= ~ Type)

dds<-DESeq(dds)

myres<-results(dds,contrast=c("Type","sgKmt2d","Vector"))
myresf<-myres[order(myres$padj),]
write.table(myresf,"sgKmt2d-vs-Vector.deseq.txt",sep="\t",row.names=TRUE)

#filter to TEtranscripts
tedata<-data[24421:nrow(data),]
myresf2<-myresf[rownames(myresf)%in%rownames(tedata),]

write.table(myresf2,"sgKmt2d-vs-Vector.deseq.TEonly.txt",sep="\t",row.names=TRUE)