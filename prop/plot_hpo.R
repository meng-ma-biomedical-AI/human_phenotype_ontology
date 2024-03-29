#!/usr/bin/env Rscript
#
# Usage: plot_hpo.R <HPO id> [HPO id] [HPO id]
#

suppressPackageStartupMessages(library(ontologyPlot))
suppressPackageStartupMessages(library(ontologyIndex))

if("ontologyIndex" %in% rownames(installed.packages()) == FALSE){
  stop("Please install the ontologyIndex package first")
}
if("ontologyPlot" %in% rownames(installed.packages()) == FALSE){
  stop("Please install the ontologyPlot package first")
}

args <- commandArgs(TRUE)
if (length(args) == 0){
  stop('Please provide HPO ID/s')
}

library(ontologyPlot)
library(ontologyIndex)

my_hpo <- args

# use the HPO terms provided by the package
# data(hpo)

# or use HPO terms provided by own OBO file
# http://stackoverflow.com/questions/1815606/rscript-determine-path-of-the-executing-script
initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
script.basename <- dirname(script.name)
hpo <- get_ontology(file = paste(script.basename, "/../data/hp.obo.gz", sep=''))
my_hpo_ancestor <- get_ancestors(hpo, my_hpo)

my_colour <- as.numeric(my_hpo_ancestor %in% my_hpo)
my_colour <- ifelse(my_colour == 1, yes = '#BEBADA', no = '#8DD3C7')

random_string <- function(length=12){
  my_rand <- sample(letters, length, replace=TRUE)
  return(paste(my_rand, collapse=''))
}

# my_outfile <- paste(random_string(), '.pdf', collapse='', sep = '')
my_outfile <- 'hpo.pdf'

pdf(file = my_outfile)

onto_plot(hpo, terms = my_hpo_ancestor, fillcolor = my_colour)

if (length(args) == 1){
  dev.off()
  quit()
}

my_hpo_ancestor_no_link <- remove_links(hpo, my_hpo_ancestor)
my_colour <- as.numeric(my_hpo_ancestor_no_link %in% my_hpo)
my_colour <- ifelse(my_colour == 1, yes = '#BEBADA', no = '#8DD3C7')
onto_plot(hpo, terms = my_hpo_ancestor_no_link, fillcolor = my_colour)
dev.off()
quit()

