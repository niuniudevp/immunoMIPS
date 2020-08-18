#!/usr/bin/Rscript
#calculates adjusted p value by each column (tumor type)
data<-read.table("merged-corPval.KMT2D.txt",sep="\t",row.names=1,header=TRUE)
tdata<-t(data)

adjdata<-tdata
for (i in (1:ncol(tdata))){
	pvals<-tdata[,i]
	adjp<-p.adjust(pvals,method="BH")
	adjdata[,i]<-adjp
}

write.table(adjdata,"merged-corPval.KMT2D.t.adjp.txt",row.names=TRUE,sep="\t")
write.table(t(adjdata),"merged-corPval.KMT2D.adjp.txt",row.names=TRUE,sep="\t")


mat<-read.table("merged-corMat.KMT2D.txt",sep="\t",header=TRUE,row.names=1)
write.table(t(mat),"merged-corMat.KMT2D.t.txt",sep="\t",row.names=TRUE)
