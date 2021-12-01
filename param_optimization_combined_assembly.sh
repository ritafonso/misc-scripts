#!/bin/bash

##parameter optimization for Stacks for combined assembly for all three freiras species (madeira deserta bermuda)
#demultiplexed files must be in the root directory in a folder called proc_radtags

values=(1 2 3 4 5 6 7 8 9)

#argument 1 is the root directory
#$1
#argument 2 is the file of population map
#$2


#subsample each population to 5 individuals each
shuf -n 5 $1/pop_map_cahow.txt > popmap_cahow_subsample_param.txt
shuf -n 5 $1/pop_map_madeira.txt > popmap_madeira_subsample_param.txt
shuf -n 5 $1/pop_map_deserta.txt > popmap_deserta_subsample_param.txt

#create a single population map for all species
cat popmap_cahow_subsample_param.txt popmap_madeira_subsample_param.txt popmap_deserta_subsample_param.txt > popmap_all_subsample_param.txt


#varying m, while M and n stay in deafault

for m in "${values[@]}"; do
	mkdir "m$m"
	denovo_map.pl -T 40 -M 2 -m "$m" -n 1 -o "./m$m"  --samples "$1/proc_radtags" --popmap "$2" --paired -X "populations: -r 0.80" -X "populations: -p 1"
done

#varying M, while m and n stay in default

for M in "${values[@]}"; do
	mkdir "M$M"
	denovo_map.pl -T 40 -M "$M" -m 3 -n 1 -o "./M$M" --samples "$1/proc_radtags" --popmap "$2" --paired -X "populations: -r 0.80" -X "populations: -p 1"
done

#varying n, while m and M stay in default

for n in "${values[@]}"; do
	mkdir "n$n"
	denovo_map.pl -T 40 -M 2 -m 3 -n "$n" -o "./n$n" --samples "$1/proc_radtags" --popmap "$2" --paired -X "populations: -r 0.80" -X "populations: -p 1"
done

#extracting nr of total assembled loci resulted from the assemblies

for t in m M n; do
	for v in "${values[@]}"; do
		for pop in madeira bermuda deserta; do
			i="$t$v"
			echo "1"
			echo ${i} > ./${i}/parameter.tsv
			echo assembled_loci > ./${i}/metric_al.tsv
			cat ./${i}/populations.log | grep $pop | grep sites: | awk -F " " '{print $10}' | awk -F "/" '{print $1}' > ./${i}/${i}_nr_assembled_loci_$pop.tsv
			paste ./${i}/parameter.tsv ./${i}/${i}_nr_assembled_loci_$pop.tsv ./${i}/metric_al.tsv  > ./${i}/${i}_assembled_loci_$pop.tsv
			rm ./${i}/${i}_nr_assembled_loci_$pop.tsv
			rm ./${i}/metric_al.tsv
		done
	done
done

#extracting nr of polymorphic loci resulted from the assemblies

for t in m M n; do
	for v in "${values[@]}"; do
		for pop in madeira bermuda deserta; do
			i="$t$v"
			echo "2"
			echo polymorphic_loci > ./${i}/metric_pl.tsv
			cat ./${i}/populations.hapstats.tsv | grep -v ^"#" | grep $pop | wc -l > ./${i}/${i}_nr_polymorphic_loci_$pop.tsv
			paste ./${i}/parameter.tsv ./${i}/${i}_nr_polymorphic_loci_$pop.tsv ./${i}/metric_pl.tsv > ./${i}/${i}_polymorphic_loci_$pop.tsv
			rm ./${i}/${i}_nr_polymorphic_loci_$pop.tsv
			rm ./${i}/metric_pl.tsv
		done
	done
done

#extracting nr of snps resulted from the assemblies

for t in m M n; do
	for v in "${values[@]}"; do
		for pop in madeira bermuda deserta; do
			i="$t$v"
			echo snps > ./${i}/metric_snps.tsv
			cat ./${i}/populations.sumstats.tsv | grep -v ^"#" | grep $pop | wc -l > ./${i}/${i}_nr_snps_$pop.tsv
			paste ./${i}/parameter.tsv ./${i}/${i}_nr_snps_$pop.tsv ./${i}/metric_snps.tsv > ./${i}/${i}_snps_$pop.tsv
			rm ./${i}/${i}_nr_snps_$pop.tsv
			rm ./${i}/metric_snps.tsv
		done
	done
done

rm ./$i/parameter.tsv

#final files for input in R script for plotting the results

cat > all_metrics_param_m.tsv
cat > all_metrics_param_M.tsv
cat > all_metrics_param_n.tsv

for i in assembled_loci polymorphic_loci snps; do
	for v in "${values[@]}"; do
		for pop in madeira bermuda deserta; do
			cat ./m${v}/m${v}_${i}_${pop}.tsv >> all_metrics_param_m_${pop}.tsv
			cat ./M$v/M${v}_${i}_${pop}.tsv >> all_metrics_param_M_${pop}.tsv
			cat ./n$v/n${v}_${i}_${pop}.tsv >> all_metrics_param_n_${pop}.tsv
		done
	done
done

#run R script plot_params_opt_combined_assembly.R for each all_metrics file

for i in m M n; do
	for pop in madeira bermuda deserta; do
		./plot_params_opt_combined_assembly.R all_metrics_param_${i}_${pop}.tsv all_metrics_plot_${i}_${pop}.png
	done
done
