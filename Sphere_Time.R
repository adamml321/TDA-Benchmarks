#Benchmark and plot evaluation speed between TDA (GUDHI, Dionysus) and TDAstats (ripser) packages
#This will look at data from a point cloud sampled from the unit sphere with various numbers of points sampled

library(TDA)
library(TDAstats)
library(bench)
library(rgl)
library(ggplot2)

####################
#Verify that the two packages produce the same results
#When running the benchmarking section, use this section to match parameters.
####################
test_sphere <- sphereUnif(190 ,2 ,r=1)
plot3d(test_sphere)

#TDAstats package (ripser)
test.phom.TDAstat <- calculate_homology(test_sphere,dim=2)
plot_barcode(test.phom.TDAstat)

#TDA package (GUDHI)
test.phom.gud <- ripsDiag(X = test_sphere, maxdimension = 2, maxscale = 1.75, library = "GUDHI", printProgress = FALSE)
plot(test.phom.gud[["diagram"]],barcode=TRUE)

#TDA package (Dionysus)
test.phom.gud <- ripsDiag(X = test_sphere, maxdimension = 2, maxscale = 1.75, library = "GUDHI", printProgress = FALSE)
plot(test.phom.gud[["diagram"]],barcode=TRUE)


#Setting up variables for Benchmarking
###################
time <- numeric(6)
points <- numeric(6)

ripser <- data.frame(points, time)
#Dion <- data.frame(points, time)
#GUD <- data.frame(points, time)
###################

#Evaluating speed and memory for various numbers of sampled points
for (i in 1:6){
  sample <- sphereUnif(10*(2^i), 2, r=1)
  
  ripser$points[i] <- 10*(2^i)
  #Dion$points[i] <- 48*i
  #GUD$points[i] <- 48*i
  
  mark.ripser <- mark(calculate_homology(sample,dim=2))
  #mark.Dion <- mark(ripsDiag(X = sample, maxdimension = 2, maxscale = 1.75, library = "Dionysus", printProgress = FALSE))
  #mark.GUD <- mark(ripsDiag(X = sample, maxdimension = 2, maxscale = 1.75, library = "GUDHI", printProgress = FALSE))
  
  ripser$time[i] <- mark.ripser$median
  
  #Dion$time[i] <- mark.Dion$median
  
  #GUD$time[i] <- mark.GUD$median
}

#Reformatting data in units of memory/time
ripser$time <- as_bench_time(ripser$time)
ripser$Algorithm <- "Ripser"

#GUD$time <- as_bench_time(GUD$time)
#GUD$Algorithm <- "GUDHI"

#Dion$time <- as_bench_time(Dion$time)
#Dion$Algorithm <- "Dionysus"


#Everything into one data frame
Sphere.benchmarks <- rbind(ripser)

#Plotting
ggplot(Sphere.benchmarks, aes(points, time)) + geom_point(aes(x = points, y = time, shape = Algorithm, color = Algorithm)) +
  labs(title="2-Sphere Sample Point Cloud", y="Evaluation Time", x="Number of Points") + theme_bw()

