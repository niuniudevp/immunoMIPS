#!/usr/bin/perl
#Identifies the FDR cutoff for each sgRNA
#Then uses that to call binary sgRNA level mutants

#A FDR cutoff of 5% would be taking the top 2 values out of the ctrl samples

use strict;
use warnings;
my $fh;
my $cut = 5;
my $samplefdr = 0;
#my $ofh;

#open($ofh,">cutoff-vs-correlation/topggenes-mtsgliver$cut.txt") || die "no";
#First let's get the sample info so we know what the control samples are
open ($fh,"<sample-info.rd2-3.ro.txt") || die "n";
<$fh>;
my %infohash;
while (<$fh>){
	s/[\r\n]//g;
	s/"//g;
	my $line = $_;
	my @lines = split ("\t",$line);
	my $sample = $lines[0];
#	$sample =~ s/\Q.varscan_Sample1//g;
	my $type = $lines[3]; # this is the column in the file with the AAV type

	if ($type =~ /Vector/){
		$infohash{$sample} = $type;
#print "$sample\t$type\n"; 	
	}
}
#print scalar keys %infohash;
close $fh;


my $ofh;
open ($ofh,">FDR-cutoffs-$samplefdr.sample-sgRNAlevel.txt")|| die "o";


#print scalar keys %infohash;
open ($fh,"<immunoMIPS-rd2-3.raw.txt") || die "nope";
my $head = <$fh>;
$head =~ s/[\r\n]//g;
$head =~ s/"//g;
my @headers = split ("\t",$head);

my @ctrlcols;
for (my $i = 1; $i < scalar @headers; $i++){
	if (defined $infohash{$headers[$i]}){
		push (@ctrlcols, $i);

#print "$headers[$i]\t$infohash{$headers[$i]}\n";
	}
}



print $head,"\n";

while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my @lines = split ("\t",$line);
	my $sgRNA = $lines[0];
	print $sgRNA;
	my @ctrldata;
	my $cutoff;
	

	foreach my $i (@ctrlcols){
		#Add a little exception for p53
		if ($sgRNA =~ /p53_sg4/){
			#if ($infohash{$headers[$i]} =~ /PBS/){
			#	push (@ctrldata,$lines[$i]);
			#}
			#else {
				push (@ctrldata,0);
			#}
		}
		else {	
			push (@ctrldata,$lines[$i]);
		}
	}
	@ctrldata = sort {$b <=> $a} @ctrldata;
	

	
	$cutoff = $ctrldata[$samplefdr];

	#print "\n*****\n\n";
	print $ofh "$sgRNA\t$cutoff\n";
	for (my $i = 1; $i < scalar @lines; $i++){
#print "$sgRNA\t$headers[$i]\t";
		my $val = $lines[$i];
#print $ofh "$val\t$cutoff\t";

	#special stipulation for duplicate sgRNAs when doing sum for binary FDR call
	#this is because we had divided them by 2 earlier, so want to see complete val 
		my $cutval = $val;
		if ($sgRNA =~ /Cdkn2a_sg5/ || $sgRNA =~ /Cdkn2a_sg2/ || $sgRNA =~ /Rpl22_sg4/ || $sgRNA =~ /Rpl22_sg5/){
			$cutval = $val * 2;
		}
		if ($val > $cutoff && $cutval >= $cut){
			if ($sgRNA !~ /Rps19_sg5/){
				#print "\t1";
				print "\t$cutval";
			}
			else {
				print "\t0";
			}
		}
		else {
			print "\t0";
		}
		#print "\n";
	}
	print "\n";
	
}	




