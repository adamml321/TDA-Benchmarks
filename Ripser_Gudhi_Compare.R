#Generate a plot comparing memory and evaluation speed between TDA (GUDHI) and TDAstats (ripser)
#This will look at samples from random and sphere-sampled data with various numbers of points sampled

library(TDA)
library(TDAstats)
library(microbenchmark)
library(bench)
library(rgl)
library(ggplot2)

####################
#2-D Circle
####################
test_circle <- circleUnif(50,r=1)

#TDAstats package (ripser)
test.phom.TDAstat <- calculate_homology(test_circle,dim=1)
plot_barcode(test.phom.TDAstat)

#TDA package (GUDHI)
test.phom.gud <- ripsDiag(X = test_circle, maxdimension = 1, maxscale = 1.75, library = "GUDHI", printProgress = FALSE)
plot(circle.phom.gud[["diagram"]],barcode=TRUE)

#Making the Speed and Memory Plots

#Setting up variables
###################
ripser.time <- numeric()
ripser.memory <- numeric()
Dion.time <- numeric()
Dion.memory <- numeric()
GUD.time <- numeric()
GUD.memory <- numeric()
points <- numeric()
###################

#Evaluating speed and memory for various numbers of sampled points
for (i in 1:5){
sample <- circleUnif(10*(2^i),r=1)
points[i] <- 10*(2^i)

bm.ripser <- mark(calculate_homology(sample,dim=1))
bm.Dion <- mark(ripsDiag(X = sample, maxdimension = 1, maxscale = 1.75, library = "Dionysus", printProgress = FALSE))
bm.GUD <- mark(ripsDiag(X = sample, maxdimension = 1, maxscale = 1.75, library = "GUDHI", printProgress = FALSE))

ripser.time[i] <- bm.ripser$median
ripser.memory[i] <- bm.ripser$mem_alloc

Dion.time[i] <- bm.Dion$median
Dion.memory[i] <- bm.Dion$mem_alloc

GUD.time[i] <- bm.GUD$median
GUD.memory[i] <- bm.GUD$mem_alloc
}

#Reformatting data in units of memory/time and putting it in a data frame
ripser.memory <- as_bench_bytes(ripser.memory)
Dion.memory <- as_bench_bytes(Dion.memory)
GUD.memory <- as_bench_bytes(GUD.memory)

ripser.time <- as_bench_time(ripser.time)
Dion.time <- as_bench_time(Dion.time)
GUD.time <- as_bench_time(GUD.time)

Circle <- data.frame(points, ripser.memory, ripser.time, Dion.memory, Dion.time, GUD.memory, GUD.time)

#Plotting
ggplot(Circle, aes(points,ripser.time)) + geom_point()
