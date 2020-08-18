#!/usr/bin/perl
use strict;
use warnings;
#iterates through all folders in folderlist
#gets the file names in each folder, prints inside that folder
#
my $fh;
my $folderlist = "folderlist.txt";

open ($fh,"<$folderlist") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my @blah = split ("_",$line);
	my $newdir = $blah[1]."_".$blah[2];	
	my $outfile = "/home/rdc55/project/GQ-RNAseq/$line.bam";
	my $file1 = "$line-merged.R1.fastq.gz";	
	my $file2 = "$line-merged.R2.fastq.gz";
	system("~/kallisto_linux-v0.43.0/kallisto quant -b 100 -t 8 -i /home/rdc55/GBM-RNAseq/mm10 -o ~/project/GQ-RNAseq/kallisto-out/$newdir ./fastq/$file1 ./fastq/$file2");	
}
