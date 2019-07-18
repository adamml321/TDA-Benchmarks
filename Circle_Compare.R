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
plot(test.phom.gud[["diagram"]],barcode=TRUE)

#Making the Speed and Memory Plots

#Setting up variables
###################
time <- numeric(5)
memory <- numeric(5)
points <- numeric(5)

ripser <- data.frame(points, time, memory)
Dion <- data.frame(points, time, memory)
GUD <- data.frame(points, time, memory)
###################

#Evaluating speed and memory for various numbers of sampled points
for (i in 1:5){
sample <- circleUnif(10*(2^i),r=1)

ripser$points[i] <- 10*(2^i)
Dion$points[i] <- 10*(2^i)
GUD$points[i] <- 10*(2^i)

mark.ripser <- mark(calculate_homology(sample,dim=1), min_iterations = 5)
mark.Dion <- mark(ripsDiag(X = sample, maxdimension = 1, maxscale = 1.75, library = "Dionysus", printProgress = FALSE), min_iterations = 5)
mark.GUD <- mark(ripsDiag(X = sample, maxdimension = 1, maxscale = 1.75, library = "GUDHI", printProgress = FALSE), min_iterations = 5)

ripser$time[i] <- mark.ripser$median
ripser$memory[i] <- mark.ripser$mem_alloc

Dion$time[i] <- mark.Dion$median
Dion$memory[i] <- mark.Dion$mem_alloc

GUD$time[i] <- mark.GUD$median
GUD$memory[i] <- mark.GUD$mem_alloc
}

#Reformatting data in units of memory/time
ripser$time <- as_bench_time(ripser$time)
ripser$memory <- as_bench_bytes(ripser$memory)
ripser$Algorithm <- "ripser"

GUD$time <- as_bench_time(GUD$time)
GUD$memory <- as_bench_bytes(GUD$memory)
GUD$Algorithm <- "GUD"

Dion$time <- as_bench_time(Dion$time)
Dion$memory <- as_bench_bytes(Dion$memory)
Dion$Algorithm <- "Dionysus"


#Everything into one data frame
Circle.benchmarks <- rbind(ripser, Dion, GUD)

#Plotting
ggplot(Circle.benchmarks, aes(points, time)) + geom_point(aes(x = points, y = time, shape = Algorithm, color = Algorithm)) +
 labs(title="Circular Sample Point Cloud", y="Evaluation Time", x="Number of Points") + theme_bw()

ggplot(Circle.benchmarks, aes(points, memory)) + geom_point(aes(x = points, y = memory, shape = Algorithm, color = Algorithm)) +
  labs(title="Circular Sample Point Cloud", y="Memory Allocation", x="Number of Points") + theme_bw()