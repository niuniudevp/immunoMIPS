#!/usr/bin/perl
use strict;
use warnings;
my $fh;

open ($fh,"<sortbams.txt") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my $file = $line;
	my $pref = $line;
	$pref =~ s/-starAligned.sortedByCoord.out.bam//g;
#	
	system("pvacseq run -e 8,9,10,11 -t 20 --iedb-install-directory /home/rdc55/project/ --tdna-vaf 0.1 --pass-only ./VEP-out/$pref.variants.filt.VEP.txt $pref-pvac H-2-Kb,H-2-Db MHCflurry ./pvac-out/");

	system("rm ./pvac-out/MHC_Class_I/*tsv_*");
	system("rm -r ./pvac-out/MHC_Class_I/log");
	system("rm -r ./pvac-out/MHC_Class_I/tmp");

}




