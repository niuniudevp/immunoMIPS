#!/usr/bin/perl
use strict;
use warnings;
#iterates through all folders in folderlist
#gets the file names in each folder, prints inside that folder
#
my $fh;
opendir DIR, "/home/rdc55/project/immune-MIPS/fastq/" or die "cant open"; #directory with fastq files
my @files = readdir DIR;
closedir DIR;
my @finalfiles;

foreach my $a (@files) {
	if ($a =~ /.fastq.gz/){
		push (@finalfiles,$a);
	}
	#So @finalfiles should have the name of the fastq.gz files
}
	
foreach my $f (@finalfiles){
	if ($f =~ /_R1/){
		my $file1 = $f;
		my $prefix = $f;
		$prefix =~ s/_R1/_R2/g;	
		my $file2 = $prefix;

		my $newf = $f;
		$newf =~ s/-merged_R1.fastq.gz//g;	
		my $outfile = "/ycga-gpfs/project/ysm/chen_sidi/rdc55/immune-MIPS/$newf.bam"; #desired output directory/file_name
		system("bwa mem -t 8 /ycga-gpfs/home/bioinfo/genomes/igenomes/Mus_musculus/UCSC/mm10/Sequence/BWAIndex/genome.fa ./fastq/$file1 ./fastq/$file2 | samtools view -S -h -b - > $outfile");
		
	}
	
}
