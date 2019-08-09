#Benchmark and plot evaluation speed between TDA (GUDHI, Dionysus) and TDAstats (ripser) packages
#This will look at data from a uniform distribution on the unit circle with various numbers of points sampled

library(TDA)
library(TDAstats)
library(microbenchmark)
library(bench)
library(rgl)
library(ggplot2)
library(profvis)

####################
#Verify that the two packages produce the same results
#When running the benchmarking section, use this section to match parameters.
####################
test_circle <- circleUnif(100,r=1)

#TDAstats package (ripser)
test.phom.TDAstat <- calculate_homology(test_circle,dim=1)
plot_barcode(test.phom.TDAstat)

#TDA package (GUDHI)
test.phom.gud <- ripsDiag(X = test_circle, maxdimension = 1, maxscale = 1.75, library = "GUDHI", printProgress = FALSE)
plot(test.phom.gud[["diagram"]],barcode=TRUE)

#TDA package (Dionysus)
test.phom.dion <- ripsDiag(X = test_circle, maxdimension = 1, maxscale = 1.75, library = "Dionysus", printProgress = FALSE)
plot(test.phom.dion[["diagram"]],barcode=TRUE)


#Setting up variables for Benchmarking
###################
time <- numeric(90)
points <- numeric(90)

ripser <- data.frame(points, time)
Dion <- data.frame(points, time)
GUD <- data.frame(points, time)
###################

#Evaluation time for various numbers of sampled points
for (i in 1:90){
  sample <- circleUnif(i+10,r=1)
  
  ripser$points[i] <- i+10
  #Dion$points[i] <- 50*i
  GUD$points[i] <- i+10
  
  mark.ripser <- mark(calculate_homology(sample,dim=1), min_iterations = 5)
  #mark.Dion <- mark(ripsDiag(X = sample, maxdimension = 1, maxscale = 1.75, library = "Dionysus", printProgress = FALSE), min_iterations = 5)
  mark.GUD <- mark(ripsDiag(X = sample, maxdimension = 1, maxscale = 1.75, library = "GUDHI", printProgress = FALSE), min_iterations = 5)
  
  ripser$time[i] <- mark.ripser$median
  
  #Dion$time[i] <- mark.Dion$median
  
  GUD$time[i] <- mark.GUD$median
}

#Reformatting data in units of time
ripser$time <- as_bench_time(ripser$time)
ripser$Algorithm <- "Ripser"

GUD$time <- as_bench_time(GUD$time)
GUD$Algorithm <- "GUD"

#Dion$time <- as_bench_time(Dion$time)
#Dion$Algorithm <- "Dionysus"


#Everything into one data frame
Circle.benchmarks <- rbind(ripser, GUD)

#Plotting
ggplot(Circle.benchmarks, aes(points, time)) + geom_point(aes(x = points, y = time, shape = Algorithm, color = Algorithm)) +
  labs(title="Circular Sample Point Cloud", y="Evaluation Time", x="Number of Points") + theme_bw()
