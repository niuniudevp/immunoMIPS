#!/usr/bin/perl
use strict;
use warnings;
my $fh;

my @files;

#open ($fh,"<fastqfiles.txt") || die "cant";
#while (<$fh>){
#        s/[\r\n]//g;
#       my $line = $_;
#	if ($line =~ /_R1_/){
#		push (@files,$line);
#	}
#
#}
#close $fh;


for (my $i = 12; $i <= 12; $i++){	
	my $file1 = "Gwatac_$i"."_BHMK77DSXX_L001_R1_001.fastq.gz"; # fastq file names
	my $file2 = $file1;
	my @info = split("_BHMK",$file1);
	my $newf = $info[0];
	$file2 =~ s/_R1_/_R2_/g;
	my $outfile = "/home/rdc55/project/RQ10416-ATAC/sortbams/$newf.sort.bam";
	my $ref = "/home/bioinfo/genomes/igenomes/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome";
 	system("bowtie2 -p 10 --very-sensitive -k 10 -x $ref -1 ./fastq/$file1 -2 ./fastq/$file2 | samtools view -u - | samtools sort -n -m 8G -@ 12 -o $outfile");
}



