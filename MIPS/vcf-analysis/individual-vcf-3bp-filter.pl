#!/usr/bin/perl
use strict;
use warnings;

my $fh;
my @files;

#First, we store the information in the mips probe file
#For each sgRNA, store the +/- cut site range
open ($fh,"<mips-probe-search-range.txt") || die "cant";
<$fh>;
my %miphash;
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my @lines = split ("\t",$line);
	my $sgRNA = $lines[3];
	my $searchstart = $lines[7];
	my $searchend = $lines[8];
	$miphash{$sgRNA} = [$searchstart,$searchend];
}
close $fh;


open ($fh,"<vcflist.txt") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	push (@files,$line);
}
close $fh;

#For each file:
foreach my $f (@files){
	my %annot;
	#Load the sgRNA annotation
	open ($fh,"<./vcf-sgRNA-annotation/$f-annot.txt") || die "cant";
	while (<$fh>){
		s/[\r\n]//g;
		my $line = $_;
		my @lines = split ("\t",$line);
		my $ky = "$lines[0].$lines[1]";
		$annot{$ky} = $lines[2];
	}
	close $fh;

	#Now open the raw vcf file
	my $ofh;
	open ($ofh,">./3bp/$f-3bp.txt") || die "n";
	open ($fh,"<./raw-vcfs/$f") || die "camt";
	my $head = <$fh>;
	chomp $head;
	print $ofh $head,"\tclosest_sgRNA\n";
	while (<$fh>){
		if ($_ !~ /^#/){
			s/[\r\n]//g;
			my $line = $_;
			my @lines = split ("\t",$line);
			#Map each line back to the sgRNA
			my $blah = "$lines[0].$lines[1]";
			my $sg = $annot{$blah};
			my $pos = $lines[1];
			my $ref = $lines[2];
			my $alt = $lines[3];

			if (length($ref) != 1){
			print "uhoh";
			}


			#Determine if insertion or deletion
			my $type;
			if ($alt =~ /\-/){
				$type = "del";
			}
			elsif ($alt =~ /\+/){
				$type = "ins";
			}

			#Figure out the length of the indel
			my $altlength;
			my @altinfo = split('/',$alt);
			my $altb = $altinfo[1];
			$altb =~ s/\-//g;
			$altb =~ s/\+//g;		
			$altlength = length($altb);

#print "$altb\t$altlength\n";
			
			
			#Obtain the start and end search positions for the sgRNA
			my @sgs;
			my $searchstart;
			my $searchend;
			if ($sg =~ /;/){
				@sgs = split (";",$sg);
				$searchstart = $miphash{$sgs[0]}[0];
				$searchend = $miphash{$sgs[0]}[1];
			}
			else {
				$searchstart = $miphash{$sg}[0];
				$searchend = $miphash{$sg}[1]; 
			}
			
			#%search is a hash that stores the basepairs that are in the search range
			my %search;			
			for (my $i = $searchstart; $i <= $searchend; $i++){
				$search{$i} = 1;
			}
			
	
			if ($type eq "del" || $type eq "ins"){
			#The deletion must overlap the search range.	
			#Test stores the basepairs that encompass the deletion
				my %test;
				my $difference = $altlength;
				
				#If deletion is one basepair, we want it to only count $pos -> one test basepair
				#So, we use < not <=
				for (my $i = $pos+1; $i <= $pos+$difference; $i++){
					$test{$i} = 1;
				}
				
				my $bool = 0;
				foreach my $k (keys %test){
					if (defined $search{$k}){
						$bool = 1;
					}
				}
				
				if ($bool == 1){
					print $ofh "$line\t";
					print $ofh "$sg\n";
				}
			}				
		}
	}
	close $ofh;
	close $fh;
}
			




	
