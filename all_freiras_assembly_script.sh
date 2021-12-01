#!/bin/bash

path=~/stacks_all_freiras_bootstrap/

#pop_map_madeira="$path/pop_map_madeira.txt"
#pop_map_deserta="$path/pop_map_deserta.txt"
#pop_map_cahow="$path/pop_map_cahow.txt"

#cat pop_map_madeira.txt pop_map_deserta.txt > pop_map_two_madeira.txt
#cat pop_map_two_madeira.txt pop_map_cahow.txt > pop_map_all_freiras.txt

echo 1

##stacks assembly

#ustacks
#mkdir assembly

#id=1

#files="PC1	PC2	PC3	PC4	PC5	PC7	PC8	PC9	PC10	PC11	PC12	PC13	PC14	PC15	PC16	PC17	PC18	PC19	PC20	PC21	PC22	PC23	PC24	\
#	PC25	PC26	PC27	PC28	PC29	PC30	PC31	PC32	PC33	PC34	PC35	PC37	PC38	PC39	PC40	PC41	PC42	PC43	PC44	PC45	PC46	PC47	PC48	\
#	PC49	PC50	PC51	PC52	PC53	PC54	PC55	PC56	PC57	PC58	PC59	PC60	PC61	PC62	PC63	PC64	PC65	PC66	PC67	PC68	PC69	PC70	PC71	\
#	PC73	PC74	PC75	PC76	PC77	PC78	PC79	PC80	PC82	PC83	PC84	PC85	PC87	PC88	PC89	PC90	PC91	PC92	PC93	PC94	PC95	PC97	PC98	\
#	PC99	PC100	PC101	PC104	PC105	PC106	PC107	PC108	PC110	PC111	PC112	PC114 PD1	PD10	PD11	PD12	PD13	PD15	PD16	PD19	PD20	PD21	PD22	\
#	PD27	PD30	PD3	PD32	PD4	PD5	PD7	PD8	PD9 PM14	PM29	PM25	PM20	PM8	PM12	PM10	PM6	PM23	PM35	PM32	PM11	PM30	PM9	\
#	PM22	PM27	PM19	PM15	PM31	PM3"

#for sample in $files; do
#	ustacks -f $path/proc_radtags/${sample}.1.fq.gz -o $path/assembly -i $id --name $sample -m 3  -M 3 -p 40 -R
#	let "id+=1"
#done
#echo 2

#cstakcs

#cstacks -P $path/assembly -M pop_map_all_freiras.txt -p 40 --report_mmatches -n 3

#sstacks

#sstacks -P $path/assembly -M pop_map_all_freiras.txt -p 40

#tsv2bam

#tsv2bam -P $path/assembly -M pop_map_all_freiras.txt -t 40 --pe-reads-dir $path/proc_radtags

#gstacks
#gstacks -P $path/assembly -M pop_map_all_freiras.txt -t 40 --rm-unpaired-reads

echo 3

#populations

for idx in $(seq 100); do
	mkdir -p "bootstrap/run${idx}"
	dir="./bootstrap/run${idx}"
	shuf -n 20 pop_map_cahow.txt > "$dir/cahow_subsample_run${idx}.txt"
	cat pop_map_two_madeira.txt "$dir/cahow_subsample_run${idx}.txt" >> "$dir/all_subsample_run${idx}.txt"
	populations -P $path/assembly -M "$dir/all_subsample_run${idx}.txt" -O $dir -t 40 -r 0.6 -p 1 --min-maf 0.05 --max-obs-het 0.6 --hwe --fasta-loci --vcf --genepop --structure --phylip \
		--fasta-samples-raw --plink --fstats
done










