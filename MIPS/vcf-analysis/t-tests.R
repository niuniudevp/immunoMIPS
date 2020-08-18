#!/usr/bin/Rscript
data<-read.table("../immunoMIPS-rd2-3.gene-avg.mTSG.0filt.txt",sep="\t",header=TRUE,row.names=1)
info<-read.table("../variant-freq-heatmap/sample-info.sort.mutcounts.0filt.txt",sep="\t",header=TRUE,row.names=1)
datas<-data[,colnames(data)%in%rownames(info)]
datas<-datas[,match(rownames(info),colnames(datas))]
all(rownames(info)==colnames(datas))
#write.table(datas,"immunoMIPS-rd2-3.gene-avg.mTSG.finalSet.ro.txt",sep="\t",row.names=TRUE)


#PD1 vs PBS subtract, pval, CTLA4 vs PBS subtract, pval
df<-matrix(nrow=56,ncol=4)
for (i in 1:nrow(datas)){
	myvals=datas[i,]
	pbsdata<-myvals[info$tx=="PBS"]
	pd1data<-myvals[info$tx=="anti-PD1"]
	ctla4data<-myvals[info$tx=="anti-CTLA4"]
	
	pd1test<-t.test(pd1data,pbsdata)$p.value
	pd1sub<-mean(as.numeric(pd1data))-mean(as.numeric(pbsdata))

	ctla4test<-t.test(ctla4data,pbsdata)$p.value
	ctla4sub<-mean(as.numeric(ctla4data))-mean(as.numeric(pbsdata))
	df[i,2]<-pd1test
	df[i,1]<-pd1sub
	df[i,4]<-ctla4test
	df[i,3]<-ctla4sub
}
rownames(df)<-rownames(datas)
colnames(df)<-c("PD1-PBS","PD1 pval","CTLA4-PBS","CTLA4-pval")
#Rps19 CTLA4 pvalue is NaN, set it to 1 for downstream plotting
df[rownames(df)=="Rps19",4]<-1

write.table(df,"avg-freq-t.tests.txt",sep="\t",row.names=TRUE)

