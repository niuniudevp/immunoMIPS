#!/usr/bin/perl
my $fh;
use strict;
use warnings;

my @files;
open ($fh,"<fastqfiles.txt")|| die "cant";
while (<$fh>){
	s/[\r\n]//g;
	push(@files,$_);
}
close $fh;

for (my $i = 1; $i <= 18; $i++){
	my @finalfiles;
	foreach my $f (@files){
		my $test = "L$i/Unaligned/";
		if ($f =~ /.fastq.gz/ && $f =~ /$test/){
			push (@finalfiles,$f);
		}
	}

	foreach my $f (@finalfiles){ 
		if ($f =~ /_R1_/){
			my $f2 = $f;
			$f2 =~ s/_R1_/_R2_/g;
			#print "$f\n$f2\n\n";
			my $bamout = "L$i.bam";
			system("bwa mem -t 8 -w 200 /ycga-gpfs/home/bioinfo/genomes/igenomes/Mus_musculus/UCSC/mm10/Sequence/BWAIndex/genome.fa $f $f2 | samtools view -hbS -> ~/project/GWEXO_MA1L/unsortbams/$bamout");
		}
	}
}
						




		
