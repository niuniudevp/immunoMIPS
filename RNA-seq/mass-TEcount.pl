#!/usr/bin/perl
my $fh;
open ($fh,"<sortbams.txt") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	#my @lines = split ("\t",$line);
	my $pref = $line;
	$pref =~ s/-starAligned.sortedByCoord.out.bam//g;
	my $gtf = "/gpfs/ycga/datasets/genomes/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf";
	my $ttf = "~/project/GQ-RNAseq/round1/STAR-out-TE-ucsc/mm10_rmsk_TE.gtf";
	
	system("TEcount -b ./STAR-out-TE-ucsc/$line --stranded reverse --sortByPos --GTF $gtf --TE $ttf --project ./STAR-out-TE-ucsc/$pref-TE");
	

}
