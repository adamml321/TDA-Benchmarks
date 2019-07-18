#Generate a plot comparing memory and evaluation speed between TDA (GUDHI) and TDAstats (ripser)
#This will look at samples from random and sphere-sampled data with various numbers of points sampled

library(TDA)
library(TDAstats)
library(microbenchmark)
library(bench)
library(rgl)
library(ggplot2)

####################
#2-Sphere
####################
test_sphere <- sphereUnif(50 ,2 ,r=0.5)
plot3d(test_sphere)

#TDAstats package (ripser)
test.phom.TDAstat <- calculate_homology(test_sphere,dim=2)
plot_barcode(test.phom.TDAstat)

#TDA package (GUDHI)
test.phom.gud <- ripsDiag(X = test_sphere, maxdimension = 2, maxscale = 0.8, library = "Dionysus", printProgress = TRUE)
plot(test.phom.gud[["diagram"]],barcode=TRUE)

#Making the Speed and Memory Plots

#Setting up variables
###################
time <- numeric(5)
memory <- numeric(5)
radius <- numeric(5)

ripser <- data.frame(radius, time, memory)
#Dion <- data.frame(points, time, memory)
#GUD <- data.frame(points, time, memory)
###################

#Evaluating speed and memory for various numbers of sampled points
for (i in 1:5){
  sample <- sphereUnif(100, 2, r=0.25*(2^i))
  
  ripser$radius[i] <- 0.25*(2^i)
  #Dion$points[i] <- 0.25*(2^i)
  #GUD$points[i] <- 0.25*(2^i)
  
  mark.ripser <- mark(calculate_homology(sample,dim=2), min_iterations = 5)
  #mark.Dion <- mark(ripsDiag(X = sample, maxdimension = 2, maxscale = 1.75, library = "Dionysus", printProgress = FALSE))
  #mark.GUD <- mark(ripsDiag(X = sample, maxdimension = 2, maxscale = 1.75, library = "GUDHI", printProgress = FALSE))
  
  ripser$time[i] <- mark.ripser$median
  ripser$memory[i] <- mark.ripser$mem_alloc
  
  #Dion$time[i] <- mark.Dion$median
  #Dion$memory[i] <- mark.Dion$mem_alloc
  
  #GUD$time[i] <- mark.GUD$median
  #GUD$memory[i] <- mark.GUD$mem_alloc
}

#Reformatting data in units of memory/time
ripser$time <- as_bench_time(ripser$time)
ripser$memory <- as_bench_bytes(ripser$memory)
ripser$Algorithm <- "ripser"

#GUD$time <- as_bench_time(GUD$time)
#GUD$memory <- as_bench_bytes(GUD$memory)
#GUD$Algorithm <- "GUDHI"

#Dion$time <- as_bench_time(Dion$time)
#Dion$memory <- as_bench_bytes(Dion$memory)
#Dion$Algorithm <- "Dionysus"


#Everything into one data frame
Sphere.benchmarks <- rbind(ripser)

#Plotting
ggplot(Sphere.benchmarks, aes(radius, time)) + geom_point(aes(x = radius, y = time)) +
  labs(title="2-Sphere Radius Comparison", y="Evaluation Time", x="Radius")

ggplot(Sphere.benchmarks, aes(radius, memory)) + geom_point(aes(x = radius, y = memory)) +
  labs(title="2-Sphere Radius Comparison", y="Memory Allocation", x="Radius")

