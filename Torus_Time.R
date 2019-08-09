#Benchmark and plot evaluation speed between TDA (GUDHI, Dionysus) and TDAstats (ripser) packages
#This will look at data from a point cloud sampled from a torus with various numbers of points sampled

library(TDA)
library(TDAstats)
library(microbenchmark)
library(bench)
library(rgl)
library(ggplot2)

####################
#Verify that the two packages produce the same results
#When running the benchmarking section, use this section to match parameters.
####################
test_torus <- torusUnif(100, 1, 5)
plot3d(test_torus)

#TDAstats package (ripser)
test.phom.TDAstat <- calculate_homology(test_torus,dim=2)
plot_barcode(test.phom.TDAstat)

#TDA package (GUDHI)
test.phom.gud <- ripsDiag(X = test_torus, maxdimension = 2, maxscale = 8, library = "GUDHI", printProgress = FALSE)
plot(test.phom.gud[["diagram"]],barcode=TRUE)

#Setting up variables for benchmarking
###################
time <- numeric(5)
points <- numeric(5)

ripser <- data.frame(points, time)
#Dion <- data.frame(points, time)
GUD <- data.frame(points, time)
###################

#Evaluating speed and memory for various numbers of sampled points
for (i in 1:5){
  sample <- torusUnif(25*i, 1, 5)
  
  ripser$points[i] <- 50*i
  #Dion$points[i] <- 50*i
  GUD$points[i] <- 50*i
  
  mark.ripser <- mark(calculate_homology(sample,dim=2))
  #mark.Dion <- mark(ripsDiag(X = sample, maxdimension = 2, maxscale = 1.75, library = "Dionysus", printProgress = FALSE))
  mark.GUD <- mark(ripsDiag(X = sample, maxdimension = 2, maxscale = 8, library = "GUDHI", printProgress = FALSE))
  
  ripser$time[i] <- mark.ripser$median
  
  #Dion$time[i] <- mark.Dion$median
  
  GUD$time[i] <- mark.GUD$median
}

#Reformatting data in units of memory/time
ripser$time <- as_bench_time(ripser$time)
ripser$Algorithm <- "Ripser"

GUD$time <- as_bench_time(GUD$time)
GUD$Algorithm <- "GUDHI"

#Dion$time <- as_bench_time(Dion$time)
#Dion$Algorithm <- "Dionysus"


#Everything into one data frame
Sphere.benchmarks <- rbind(ripser, GUD)

#Plotting
ggplot(Sphere.benchmarks, aes(points, time)) + geom_point(aes(x = points, y = time, shape = Algorithm, color = Algorithm)) +
  labs(title="Torus Sample Point Cloud", y="Evaluation Time", x="Number of Points") + theme_bw()

