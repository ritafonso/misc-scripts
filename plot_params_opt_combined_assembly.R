#!/usr/bin/Rscript

# r script to plot the metrics resulted from parameter optimization of stacks assembly
# input file contains all the metrics of different values of one parameter. It should contain two columns: metric (e.g. m2) and value for that metric (e.g. 2987)
# this script requires two arguments: an input file and an output name
#the output name should include the extention (e.g .png)


library("ggplot2")
library("ggrepel")

args <- commandArgs(trailingOnly = TRUE)

#arguments

input_file <- args[1]
output_name <- args[2]

#import the input file

input <- read.csv(file = input_file, sep = "\t", header = FALSE)
colnames(input) <- c("param","value","metric") 
input$param <- as.factor(input$param)
input$metric <- as.factor(input$metric)

##plot the results in a scatter plot

png(output_name, width= 1200, height =600)

ggplot(input, aes(param, value, group=1)) +
	geom_point(size=3, fill="darkblue", shape=23)+
	facet_wrap(input$metric, scales = "free", strip.position = "left", 
             labeller = as_labeller(c(assembled_loci = "Nr of assembled loci", polymorphic_loci = "Nr polymorphic loci", snps="Nr of SNPs"))) +
  ylab(NULL) +
  theme(strip.background.y = element_blank(),
        strip.placement = "outside",  axis.line = element_line(size = 1, linetype = "solid",
                                                               colour = "black"), 
        strip.text.y = element_text(size = rel(2), colour = "black"),
        panel.background = element_rect(color = "black", fill = "lightgrey", linetype = "solid", size=1)) +
  geom_text_repel(aes(label= value))+
  xlab(NULL)+
  geom_line(linetype="longdash", size=0.9)

dev.off()
