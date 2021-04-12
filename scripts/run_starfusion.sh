
## starfusion 1.10.0
## STAR 2.7.8a
## GRCh38 + Gencode v37

echo "## --------------------------------------"

echo "[ " `date` " ] Detect gene fusions: starfusion"

echo -e "Run STAR first ..."
## starfusion wiki:

STAR \
	--outSAMattrRGline $RGstringSTARstring \
	--outFileNamePrefix $out1 \
	--runThreadN $threads \
	--genomeDir $starIndex \
	--genomeLoad NoSharedMemory \
	--readFilesIn $in1 $in2 \
	--readFilesCommand "gunzip -c" \
	--outReadsUnmapped None \
	--twopassMode Basic \
	--outSAMstrandField intronMotif \
	--outSAMunmapped Within \
	--chimSegmentMin 12 \
	--chimJunctionOverhangMin 8 \
	--chimOutJunctionFormat 1 \
	--alignSJDBoverhangMin 10 \
	--alignMatesGapMax 100000 \
	--alignIntronMax 100000 \
	--alignSJstitchMismatchNmax 5 -1 5 5 \
	--chimMultimapScoreRange 3 \
	--chimScoreJunctionNonGTAG -4 \
	--chimMultimapNmax 20 \
	--chimNonchimScoreDropMin 10 \
	--peOverlapNbasesMin 12 \
	--peOverlapMMp 0.1 \
	--alignInsertionFlush Right \
	--alignSplicedMateMapLminOverLmate 0 \
	--alignSplicedMateMapLmin 30 \
	--outSAMtype BAM Unsorted \
	--chimOutType Junctions

echo "Run star-fusion ... "
STAR-Fusion \
	--genome_lib_dir $CTATResourceLib \
	--chimeric_junction ${out1}Chimeric.out.junction \
	--output_dir ${out3} \
	--CPU $threads


