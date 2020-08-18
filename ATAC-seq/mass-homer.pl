#!/usr/bin/perl
#annotate bed files of peaks
use strict;
use warnings;
my @files;
my $fh;

open ($fh,"<peakfiles.txt") || die "no";
while (<$fh>){
	s/[\r\n]//g;
	my $file = $_;
	$file =~ s/.txt/.bed/g;
	push (@files,$file);
}
close $fh;

foreach my $f (@files){
	my $outf = $f;
	$outf =~ s/.txt/.annot.txt/g;
	my $outdir = $f;
	$outdir =~ s/.peaks.bed/-motif/g;
	#system("annotatePeaks.pl $f mm10 > ./peak-annot/$outf");
#print "$f\t$outdir\n";
	system("findMotifsGenome.pl $f mm10 $outdir -size 200 -mask");
}

