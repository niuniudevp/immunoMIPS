#!/usr/bin/perl
my $fh;
open ($fh,"<mdbams.txt") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	#my @lines = split ("\t",$line);
	my $pref = $line;
	$pref =~ s/-starAligned.sortedByCoord.out.md.bam//g;
	my $fadir = "/gpfs/ycga/datasets/genomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa";
	#run Manta
	system("mkdir ./strelka-out-ucsc/$pref");
	system("/home/rdc55/project/GWEXO_MA1L/strelka-2.9.2.centos6_x86_64/bin/configureStrelkaGermlineWorkflow.py --rna --bam ./STAR-out-ucsc/$line --referenceFasta $fadir --runDir ./strelka-out-ucsc/$pref/");
	system("./strelka-out-ucsc/$pref/runWorkflow.py -m local -j 20"); 
}
