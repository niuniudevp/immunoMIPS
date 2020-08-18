#!/usr/bin/perl
use strict;
use warnings;

#Removes any row that is >3 bp from sgRNA cut site
my $fh;
my $data = "vcflist.txt"; # list of vcf files from VarScan

my $bed = "mips-probe-search-range.txt"; # text file with target sites of the sgRNAs
my %sghash;
open ($fh,"<$bed") || die "cat";
<$fh>;
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my @lines = split ("\t",$line);
	my $sgid = $lines[3];
	my $start = $lines[1];
	my $chr = $lines[0];
	my $end = $lines[2];
	my $strand = $lines[5];
	my $middle = ($start + $end)/2;
	my $cutstart;
	my $cutend;

	if ($strand eq "-"){
		$cutstart = $middle - 20;
		$cutend = $middle;
#print "$cutstart\t$middle\t$cutend\n";
	}
	elsif ($strand eq "+"){
		$cutstart = $middle;
		$cutend = $middle + 20;
	}
			
	
	$sghash{$sgid} = [$chr,$start,$end,$middle,$strand,$cutstart,$cutend];
#print "$chr\t$start\t$end\t$middle\t$strand\t$cutstart\t$cutend\n";
}
close $fh;


		
my @files;

open ($fh,"<$data") || die "Cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	push (@files,$_);
}
close $fh;

my $ofh;
foreach my $f (@files){
	open ($fh,"<./raw-vcfs/$f") || die "Cant"; # folder with raw vcf output files
	open ($ofh,">./vcf-sgRNA-annotation/$f-annot.txt") || die "cant"; #output folder for sgRNA annotation per variant
	<$fh>;
	
	my $counter = 0;
	while (<$fh>){
		my @alldistances;
		$counter++;
		my %temphash;
		s/[\r\n]//g;
		my $line = $_;
		my @lines = split ("\t",$line);	
		my $chr = $lines[0];
		my $pos = $lines[1];
		my $distance;
		my $targetsg = "";
		my $bool = 0;	
	#Run through sghash to pick the best one
		foreach my $k (keys %sghash){
			my $sgchr = $sghash{$k}[0];
			my $cutstart = $sghash{$k}[5];
			my $cutend = $sghash{$k}[6];
			my $middle = $sghash{$k}[3];
		
			if ($chr eq $sgchr){
			#Distance from indel site to center of MIPS (i..e, cut site)
			#if ($pos >= $cutstart && $pos <= $cutend){
				$distance = abs($pos - $middle);
				push (@alldistances,$distance);
				$temphash{$k} = $distance;
			}
		}
		#
		my @sortdists = sort {$a <=> $b} @alldistances;
		my $min = $sortdists[0];

		my @matches;
		foreach my $k (keys %temphash){
			
			if ($temphash{$k} == $min){
				push (@matches,$k);
				
			}
		}	
		print $ofh "$chr\t$pos\t";
		if (scalar @matches >= 2){
			foreach my $sg (@matches){
				print $ofh "$sg;";
			}
		}
		else {
			print $ofh "$matches[0]";
		}
		print $ofh "\t$temphash{$matches[0]}\t$sghash{$matches[0]}[4]\n";		
	}

}
close $fh;




