#!/usr/bin/perl
use strict;
use warnings;
my $fh;
open ($fh,"<sortbams.txt") || die "cat"; # text file with list of sorted bam files.
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my $pref = $line;
	#if ($pref =~ /_/){
	#my @temp = split ("_",$pref);
	#$pref = $temp[0];
	$pref =~ s/.bam.sort.bam//g;
#	pref =~ s/merged.bam/intersectMIPS.bam/g;
	system ("bedtools intersect -a ./sortbams/$_ -b mtsgp53_sg_cutsite_f30_mm10-sort.bed > ./intersectbams/$pref.intersect.bam");
}

