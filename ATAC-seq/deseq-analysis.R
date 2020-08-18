#!/usr/bin/Rscript
library(DESeq2)
data<-read.table("readscores.narrow.format.txt",sep="\t",header=TRUE,row.names=1) # raw read counts, reformatted to have the entire region in each row name
info<-read.table("sample-info.txt",sep="\t",header=TRUE,row.names=1) #annotation file
rowcounts<-rowSums(data)

dataf<-data[rowSums(data)>=500,]
all(rownames(info)==colnames(dataf))

dds<-DESeqDataSetFromMatrix(countData=dataf,colData=info,design= ~ condition)

dds<-DESeq(dds)


v10_v0<-results(dds,contrast=c("condition","Vector_10g","Vector_0g"))
v10_v0f<-v10_v0[order(v10_v0$padj),]
write.table(v10_v0f,"vec10g-vs-vec0g.txt",sep="\t",row.names=TRUE)

m0_v0<-results(dds,contrast=c("condition","sgMll2_0g","Vector_0g"))
m0_v0f<-m0_v0[order(m0_v0$padj),]
write.table(m0_v0f,"mll0g-vs-vec0g.txt",sep="\t",row.names=TRUE)

m10_m0<-results(dds,contrast=c("condition","sgMll2_10g","sgMll2_0g"))
m10_m0f<-m10_m0[order(m10_m0$padj),]
write.table(m10_m0f,"mll_10g-vs-mll_0g.txt",sep="\t",row.names=TRUE)

m10_v10<-results(dds,contrast=c("condition","sgMll2_10g","Vector_10g"))
m10_v10f<-m10_v10[order(m10_v10$padj),]
write.table(m10_v10f,"mll_10g-vs-vec10g.txt",sep="\t",row.names=TRUE)

m10_v0<-results(dds,contrast=c("condition","sgMll2_10g","Vector_0g"))
m10_v0f<-m10_v0[order(m10_v0$padj),]
write.table(m10_v0f,"mll_10g-vs-vec0g.txt",sep="\t",row.names=TRUE)


library(NMF)
cordata<-cor(dataf,method="spearman")
aheatmap(cordata,treeheight=15,col="BuPu:100",border="black")







