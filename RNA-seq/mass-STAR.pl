#!/usr/bin/perl
use strict;
use warnings;

my @files;

my $fh;
open ($fh,"<fastqfiles.txt") || die "no";
while (<$fh>){
	s/[\r\n]//g;
	my $r1 = $_;
	my $r2 = $r1;
	$r2 =~ s/R1/R2/g;
	my @info = split ("_",$r1);
	my $sample  = $info[0].$info[1].$info[2];

	system("STAR --readFilesCommand zcat --runThreadN 20 --genomeDir ~/project/GQ-RNAseq/STAR-index-mm10-ucsc/ --readFilesIn ./fastq/$r1 ./fastq/$r2 --outFileNamePrefix ./STAR-out-ucsc/$sample-star --outSAMtype BAM SortedByCoordinate");
}
