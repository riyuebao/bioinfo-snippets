
## arriba 2.1.0
## STAR 2.7.8a
## GRCh38 + Gencode v37

echo "## --------------------------------------"

arribaDB=
arribaBlastlist=${arribaDB}/blacklist_hg38_GRCh38_v2.1.0.tsv.gz
arribaKnownFusions=${arribaDB}/known_fusions_hg38_GRCh38_v2.1.0.tsv.gz
arribaProtDomains=${arribaDB}/protein_domains_hg38_GRCh38_v2.1.0.gff3
arribaWGSsvs=

echo "## --------------------------------------"

echo "[ " `date` " ] Detect gene fusions: arriba"

echo -e "Run STAR and pipe into arriba ..."
STAR \
	--outSAMattrRGline $RGstringSTARstring \
	--outFileNamePrefix $out1 \
	--runThreadN $threads \
	--genomeDir $starIndex \
	--genomeLoad NoSharedMemory \
	--readFilesIn $in1 $in2 \
	--readFilesCommand zcat \
	--outStd BAM_Unsorted \
	--outSAMtype BAM Unsorted \
	--outSAMunmapped Within \
	--outBAMcompression 0 \
	--outFilterMultimapNmax 50 \
	--peOverlapNbasesMin 10 \
	--alignSplicedMateMapLminOverLmate 0.5 \
	--alignSJstitchMismatchNmax 5 -1 5 5 \
	--chimSegmentMin 10 \
	--chimOutType WithinBAM HardClip \
	--chimJunctionOverhangMin 10 \
	--chimScoreDropMax 30 \
	--chimScoreJunctionNonGTAG 0 \
	--chimScoreSeparation 1 \
	--chimSegmentReadGapMax 3 \
	--chimMultimapNmax 50 |

tee ${out1}Aligned.out.bam |

arriba \
	-x /dev/stdin \
	-o ${out1}fusions.tsv \
	-O ${out1}fusions.discarded.tsv \
	-s $arribaStrand \
	-a $refGenome -g $refGTF \
	-b $arribaBlastlist \
	-k $arribaKnownFusions \
	-t $arribaKnownFusions \
	-p $arribaProtDomains \
	-X 
	
## in case the fusion I wanted was discarded... turn on -X
## -X  To reduce the runtime and file size, by default, the columns 'fusion_transcript', 'peptide_sequence', and 'read_identifiers' are left empty in the file containing discarded fusion candidates (see parameter -O). When this flag is set, this extra  information is reported in the discarded fusions file.

