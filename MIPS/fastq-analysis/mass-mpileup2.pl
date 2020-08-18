#!/usr/bin/perl
use strict;
use warnings;
my $fh;

my $fasta = "/ycga-gpfs/home/bioinfo/genomes/igenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa"; #location of reference genome


open ($fh,"<intersectbams.txt") || die "cant"; # list of intersected bam files
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my $pref = $line;
	$pref =~ s/.intersect.bam//g;
	system ("samtools mpileup -d 1000000000 -B -q 10 -f $fasta ./intersectbams/$line | java -jar VarScan.v2.3.9.jar pileup2indel --min-coverage 1 --min-reads2 1 --min-var-freq 0.001 --p-value 0.05 > ./vcfs/$pref.varscan.vcf");
}
