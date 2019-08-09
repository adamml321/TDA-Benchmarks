library(TDA)
library(TDAstats)
library(bench)
library(ggplot2)
library(profmem)



test_sphere <- sphereUnif(200 ,2 ,r=1)

## code to be profiled
p <- profmem({ test.phom.TDAstat <- calculate_homology(test_sphere,dim=2)})

q <- profmem({test.phom.gud <- ripsDiag(X = test_sphere, maxdimension = 2, maxscale = 1.75, library = "GUDHI", printProgress = FALSE)})
q
