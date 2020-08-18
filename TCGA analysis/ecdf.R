#!/usr/bin/Rscript
#Plots CDF
library(lattice)
library(latticeExtra)
pos<-read.table("merged-KMT2D-positive-correl.txt",sep="\t",header=TRUE,row.names=1)
neg<-read.table("merged-KMT2D-negative-correl.txt",sep="\t",header=TRUE,row.names=1)

poscdf<-ecdf(pos$NumTypesSig)
negcdf<-ecdf(neg$NumTypesSig)
#ecdfplot(~NumTypesSig,data=pos,auto.key=list(space="right"),lwd=5,col=c("red3"))
#ecdfplot(~NumTypesSig,data=neg,auto.key=list(space="right"),lwd=5,col=c("deepskyblue1"))


plot(poscdf,verticals=TRUE,do.points=FALSE,col="red3",lwd=4)
plot(negcdf,verticals=TRUE,do.points=FALSE,col="deepskyblue2",add=TRUE,lwd=4)
abline(h=0.95,lty=3)
