library(TDA)
library(TDAstats)
library(bench)
library(rgl)
library(ggplot2)

####################
#Verify that the two packages produce the same results
#When running the benchmarking section, use this section to match parameters.
####################
test_sphere1 <- sphereUnif(50 ,2 ,r=1)
test_sphere1[,1] <- test_sphere1[,1]+3

test_sphere2 <- sphereUnif(50 ,2 ,r=1)

doublesphere <- rbind(test_sphere1, test_sphere2)

plot3d(doublesphere)

#TDAstats package (ripser)
test.phom.TDAstat <- calculate_homology(doublesphere,dim=2)
plot_barcode(test.phom.TDAstat)

#TDA package (GUDHI)
test.phom.gud <- ripsDiag(X = doublesphere, maxdimension = 2, maxscale = 1.75, library = "GUDHI", printProgress = FALSE)
plot(test.phom.gud[["diagram"]],barcode=TRUE)
