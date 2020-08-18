#!/usr/bin/Rscript

data<-read.table("avg-freq-t.tests.txt",sep="\t",header=TRUE,row.names=1) # t test results
#Get the data points that need red
#REd is significant with ad j pval < 0.05

#first we do PD1 volcano
library(ggplot2)
downdata<-data[data$PD1.pval < 0.05 & data$PD1.PBS < 0,]
updata<-data[data$PD1.pval < 0.05 & data$PD1.PBS > 0,]
normdata<-data[data$PD1.pval >= 0.05,]
data$genes<-rownames(data)

library(ggrepel)
colScale <- scale_colour_manual(values=c("red3","gray78","navy"))
pdf("PD1.volcano.pdf",height=4,width=4,useDingbats=FALSE)
g<-ggplot(data,aes(data$PD1.PBS,log2(data$PD1.pval)*-1))+geom_point(pch=19,alpha=0.7,cex=3,data=normdata,aes(x=normdata$PD1.PBS,y=log2(normdata$PD1.pval)*-1,color="gray78"))+geom_point(pch=19,cex=3,alpha=0.7,data=downdata,aes(x=downdata$PD1.PBS,y=log2(downdata$PD1.pval)*-1,color="red3"))+geom_point(pch=19,cex=3,alpha=0.7,data=updata,aes(x=updata$PD1.PBS,y=log2(updata$PD1.pval)*-1,color="forestgreen"))+colScale+theme_classic()+ theme(legend.position="none")+geom_text_repel(data=subset(data,PD1.pval < 0.05),aes(x=PD1.PBS,y=log2(PD1.pval)*-1,label=genes,cex=0.01),vjust=0,hjust=0.5,size=2)
g
dev.off()

#now we do CTLA4 volcano
library(ggplot2)
downdata<-data[data$CTLA4.pval < 0.05 & data$CTLA4.PBS < 0,]
updata<-data[data$CTLA4.pval < 0.05 & data$CTLA4.PBS > 0,]
normdata<-data[data$CTLA4.pval >= 0.05,]
data$genes<-rownames(data)

library(ggrepel)
colScale <- scale_colour_manual(values=c("red3","gray78","navy"))
pdf("CTLA4.volcano.pdf",height=4,width=4,useDingbats=FALSE)
g<-ggplot(data,aes(data$CTLA4.PBS,log2(data$CTLA4.pval)*-1))+geom_point(pch=19,cex=3,alpha=0.7,data=normdata,aes(x=normdata$CTLA4.PBS,y=log2(normdata$CTLA4.pval)*-1,color="gray78"))+geom_point(pch=19,cex=3,alpha=0.7,data=downdata,aes(x=downdata$CTLA4.PBS,y=log2(downdata$CTLA4.pval)*-1,color="red3"))+geom_point(pch=19,cex=3,alpha=0.7,data=updata,aes(x=updata$CTLA4.PBS,y=log2(updata$CTLA4.pval)*-1,color="forestgreen"))+colScale+theme_classic()+ theme(legend.position="none")+geom_text_repel(data=subset(data,CTLA4.pval < 0.05),aes(x=CTLA4.PBS,y=log2(CTLA4.pval)*-1,label=genes,cex=0.01),vjust=0,hjust=0.5,size=2)
g
dev.off()
