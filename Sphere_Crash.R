library(TDA)
library(TDAstats)
library(microbenchmark)
library(bench)
library(rgl)
library(ggplot2)

sample <- sphereUnif(500, 2, r=1)

mark.ripser <- mark(calculate_homology(sample,dim=2))
mark.GUD <- mark(ripsDiag(X = sample, maxdimension = 2, maxscale = 1.75, library = "GUDHI", printProgress = FALSE))