#!/usr/bin/env Rscript
library(psych)
files <- list.files(path=".", pattern="*xcell.txt", full.names=T, recursive=FALSE)
lapply(files, function(x) {
	data <- read.table(x, header=TRUE,row.names=1,sep="\t")
	tdata<-t(data)
	cordata<-corr.test(tdata,method="spearman",adjust="none")
	cormat<-cordata$r
	corpval<-cordata$p
	write.table(cormat, paste(x,"corMat.txt",sep=""), sep="\t", quote=F, row.names=TRUE, col.names=TRUE)
	write.table(corpval, paste(x,"corPval.txt",sep=""), sep="\t", quote=F, row.names=TRUE, col.names=TRUE)
})
