#!/usr/bin/perl
my $fh;
open ($fh,"<mdbams.txt") || die "cant";
while (<$fh>){
#for (my $i = 1; $i <= 6; $i++){
	my $file = $_;
	$file =~ s/[\r\n]//g;
	my $prefix = $file;
	$prefix =~ s/-starAligned.sortedByCoord.out.md.bam//g;
	system("read_distribution.py -i ./STAR-out-ucsc/$file  -r mm10_refseq.bed > ./RSeQC-out-ucsc/$prefix.distribution.txt");
	#system("mismatch_profile.py -i ./STAR-out/RL$i-starAligned.sortedByCoord.out.md.bam -l 101 -o ./RSeQC-out/RL$i -n 10000000");
	#system("junction_annotation.py -i ./STAR-out/RL$i-starAligned.sortedByCoord.out.md.bam -r mm10_refseq.bed -o ./RSeQC-out/RL$i.junction.");
}
