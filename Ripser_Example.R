library(TDA)
library(TDAstats)
library(bench)
library(ggplot2)

#This is the linked dataset from the ripser website that they use for their benchmarking claim.
example <- read.csv("ripser_example.csv", header=FALSE)
example <- as.matrix(example)

example.phom.Rips <- calculate_homology(example,dim=2, format="distmat")
plot_barcode(example.phom.Rips)

example.phom.GUD <- ripsDiag(X = example, maxdimension = 2, maxscale = 1.6, printProgress = FALSE, dist="arbitrary")
plot(example.phom.GUD[["diagram"]], barcode=TRUE)

mark.ripser <- mark(calculate_homology(example,dim=2), min_iterations = 10)
mark.GUD <- mark(ripsDiag(X = example, maxdimension = 2, maxscale = 10, printProgress = FALSE), min_iterations = 10)

mark.ripser$median
mark.GUD$median
