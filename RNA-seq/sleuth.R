#!/usr/bin/Rscript
library(sleuth)
##this is essentially taken from the sleuth tutorial page, so reference that if confused
#this part is just to map ENSG IDs to genes
tx2gene <- function(){
	mart <- biomaRt::useMart(biomart = "ensembl", dataset = "mmusculus_gene_ensembl")
	t2g <- biomaRt::getBM(attributes = c("ensembl_transcript_id", "ensembl_gene_id",
            	"external_gene_name"), mart = mart)
	t2g <- dplyr::rename(t2g, target_id = ensembl_transcript_id,
                 	ens_gene = ensembl_gene_id, ext_gene = external_gene_name)
	return(t2g)
	}
t2g <- tx2gene()


#####
goi<-"Mll2"

#####

#where your kallist output is
base_dir <- "C:/CRISPR/GQ-RNAseq"
sample_id<-dir(file.path(base_dir,"kallisto-out"))
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "kallisto-out", id))

kal_dirs <- kal_dirs[grepl("SC07",names(kal_dirs)) | grepl(goi,names(kal_dirs))]

#set up comparison matrix
s2c <- read.table(file.path(base_dir, "sample-info.txt"), header = TRUE, stringsAsFactors=FALSE,sep="\t")
s2c <- s2c[grepl("SC07",s2c$sample) | grepl(goi,s2c$sample),]

#adds the kallisto directory to a path column
s2c <- dplyr::mutate(s2c, path = kal_dirs)
so <- sleuth_prep(s2c,~type, extra_bootstrap_summary = TRUE, num_cores=1,target_mapping=t2g,aggregation_column="ens_gene")

# this returns a list, with an matrix element called 'data'
#norm <- sleuth_to_matrix(so, 'obs_norm', 'scaled_reads_per_base')
#write.table(norm,paste("norm-gene-data.",goi,".txt",sep=""),sep="\t",row.names=TRUE)
norm <- sleuth_to_matrix(so, 'obs_norm', 'tpm')
write.table(norm,paste("norm-transcript-data.",goi,".txt",sep=""),sep="\t",row.names=TRUE)
#raw <- sleuth_to_matrix(so, 'obs_raw', 'tpm')
#head(norm$data)


#Run the differential expression
########################
so.fit <- sleuth_fit(so)
so.wt <- sleuth_wt(so.fit,"typeVector")
results_table <- sleuth_results(so.wt, 'typeVector', test_type = 'wt',show_all=TRUE,pval_aggregate=FALSE)
filtresults<-results_table[complete.cases(results_table),]
head(filtresults)
filtresults$b <- filtresults$b*-1
write.table(filtresults,paste("wald.",goi,"-vs-NTC.difex.gene.txt",sep=""),sep="\t",row.names=FALSE)
sleuth_live(so.wt)




