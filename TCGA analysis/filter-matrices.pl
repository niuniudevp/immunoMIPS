#!/usr/bin/perl

use strict;
use warnings;
my $fh;
my %mathash;
my %negmathash;
open ($fh,"<merged-corMat.KMT2D.t.txt") || die "cant";
<$fh>;
my $counter = 1;
while (<$fh>){
	s/[\r\n]//g;
	s/"//g;
	my $line = $_;
	my @lines = split ("\t",$line);
	for (my $i = 1; $i < scalar @lines; $i++){
		if ($lines[$i] ne "NA"){
			if ($lines[$i] > 0){
				$mathash{"$counter&$i"} = $lines[$i];
			}
			elsif ($lines[$i] < 0){
				$negmathash{"$counter&$i"} = $lines[$i];
			}
		}
	}
	$counter++;
}
close $fh;

###now with pval matrix
my %pvalhash;
open ($fh,"<merged-corPval.KMT2D.t.adjp.txt") || die "cant";
my $head = <$fh>;
$head =~ s/[\r\n]//g;
$head =~ s/"//g;
my @headers = split ("\t",$head);
$counter = 1;
my %snos;
while (<$fh>){
	s/[\r\n]//g;
	s/"//g;
	my $line = $_;
	my @lines = split ("\t",$line);
	for (my $i = 1; $i < scalar @lines; $i++){
		if ($lines[$i] ne "NA"){
			if ($lines[$i] < 0.05){
				$pvalhash{"$counter&$i"} = $lines[$i];
			}
		}
	}
	$snos{$counter} = $lines[0];
	$counter++;
	
}
close $fh;

#print the significant positives
my $ofh;
my $ofh2;
open ($ofh,">positive-sig-corr.KMT2D.mat.txt") || die "cant";
open ($ofh2,">positive-sig-corr.KMT2D.pval.txt") || die "cant";
print $ofh "$head\n";
print $ofh2 "$head\n";
for (my $i = 1; $i < $counter; $i++){
	print $ofh $snos{$i};
	print $ofh2 $snos{$i};
	for (my $j = 1; $j < scalar @headers; $j++){
		my $k = "$i&$j";
		if (defined $pvalhash{$k} && defined $mathash{$k}){
			print $ofh "\t$mathash{$k}";
			print $ofh2 "\t$pvalhash{$k}";
		}
		else {
			print $ofh "\t0";
			print $ofh2 "\t0";
		}
	}
	print $ofh "\n";
	print $ofh2 "\n";
}
close $ofh2;
close $ofh;

#prin the significant negatives
open ($ofh,">negative-sig-corr.KMT2D.mat.txt") || die "cant";
open ($ofh2,">negative-sig-corr.KMT2D.pval.txt") || die "cant";
print $ofh "$head\n";
print $ofh2 "$head\n";
for (my $i = 1; $i < $counter; $i++){
	print $ofh $snos{$i};
	print $ofh2 $snos{$i};
	for (my $j = 1; $j < scalar @headers; $j++){
		my $k = "$i&$j";
		if (defined $pvalhash{$k} && defined $negmathash{$k}){
			print $ofh "\t$negmathash{$k}";
			print $ofh2 "\t$pvalhash{$k}";
		}
		else {
			print $ofh "\t0";
			print $ofh2 "\t0";
		}
	}
	print $ofh "\n";
	print $ofh2 "\n";
}





