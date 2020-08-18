#!/usr/bin/perl
#Collapses each of the final filtered 3bp.txt files into a table, sgRNA level
#This collapser works on individual files

use strict;
use warnings;
my $fh;
my @files;
open ($fh,"<3bpvcfslist.txt") || die "cant"; # list of filtered vcf files
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	push (@files,$line);
}
close $fh;

#Get a list of all the sgRNAs
my %sglist;
open ($fh,"<mips-probe-search-range.txt") || die "Cant";
<$fh>;
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my @lines = split ("\t",$line);
	my $sgRNA = $lines[3];
	$sglist{$sgRNA} = 1;
}
close $fh;

#Initialize the hash to have #files values
#these are off-by-one indexed
my %bighash;
for (my $i = 0; $i < scalar @files; $i++){
	foreach my $k (keys %sglist){
		$bighash{$k}[$i] = 0;
	}
}
my @newfiles;
my $counter = 0;
foreach my $f (@files){
	open ($fh,"<./3bp/$f") || die "cant";
	<$fh>;
	$f =~ s/[\r\n]//g;
	#Get an abbreviated file name
	my @bleh = split ("\Q.",$f);
	my @haha = split ("SR",$bleh[0]);
	#my $filenumber = $haha[1];
	#my $indexnumber = $filenumber - 1;
	my $indexnumber = $counter;
	$counter++;	
	my $newfile = $haha[0];
	push (@newfiles,$newfile);

	while (<$fh>){
		s/[\r\n]//g;
		my $line = $_;
		my @lines = split ("\t",$line);
		my $freq = $lines[6];
		$freq =~ s/%//g;
		my $sgRNA = $lines[19];
		my @sgRNAs;
		if ($sgRNA =~ /;/){
			@sgRNAs = split (";",$sgRNA);
		
			foreach my $f (@sgRNAs){
				$bighash{$f}[$indexnumber] += $freq/2;
			}
		}
		else {
			$bighash{$sgRNA}[$indexnumber] += $freq;
		}
	}
}

#Now we print everything!
print "sgRNA";

foreach my $f (@newfiles){
	print "\t$f";
}
print "\n";

foreach my $k (sort keys %bighash){
	print "$k";
	my @data = @{$bighash{$k}};
	for (my $i = 0; $i < scalar @data; $i++){
		print "\t$data[$i]";
	}
	print "\n";
}
	
	

		

		
		
