#!/usr/bin/Rscript
data<-read.table("../immunoMIPS-rd2-3.gene-avg.txavg-pbsavg.mTSG.0filt.txt",sep="\t",header=TRUE)
library(ggplot2)
library(ggrepel)
data$color<-""

ttests<-read.table("avg-freq-t.tests.txt",sep="\t",header=TRUE,row.names=1) # t test results
ttests$pd1neglogp<-log10(ttests$PD1.pval)*-1
all(rownames(ttests)==data[,1])
data[data$anti.PD1>1 | data$anti.CTLA4 >1,]$color<-"red"
data[data$anti.PD1 < -1 | data$anti.CTLA4 < -1,]$color<-"blue"
data[(data$color != "red") & (data$color != "blue"),]$color<-"black"
#data[data$anti.PD1>1 & data$anti.CTLA4 < 1,]$color<-"black"
#ggplot(data=data,aes(x=anti.PD1,y=anti.CTLA4))+ geom_point(aes(fill=as.factor(data$color)),pch=21,cex=2)+theme_bw()+geom_text_repel(data=data,label=data$Gene)+scale_fill_manual(values=c("black","deepskyblue3","red3"))

#ggplot(data=data,aes(x=anti.CTLA4,y=anti.PD1))+ geom_point(aes(fill=as.factor(data$color)),pch=21,cex=2)+theme_bw()+geom_text_repel(data=data,label=data$Gene)+scale_fill_manual(values=c("black","deepskyblue3","red3"))


pdf(file="scatter-plot-select-labs.pvals.0filt.pdf",height=4.6,width=6,useDingbats=FALSE)
ggplot(data=data,aes(x=anti.CTLA4,y=anti.PD1))+ geom_point(aes(color=as.factor(data$color)),pch=19,cex=2)+theme_bw()+geom_text_repel(data=subset(data,data$anti.PD1< -1 | data$anti.CTLA4 < -1),label=subset(data,data$anti.PD1< -1 | data$anti.CTLA4 < -1)[,1])+geom_text_repel(data=subset(data,data$anti.PD1>1 | data$anti.CTLA4 >1),label=subset(data,data$anti.PD1>1 | data$anti.CTLA4 >1)[,1])+scale_color_manual(values=c("black","deepskyblue3","red3"))+xlim(c(-2.2,2.2))+ylim(c(-2.3,2.3))
dev.off()
