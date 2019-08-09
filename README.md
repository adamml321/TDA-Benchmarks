# TDA-Benchmarks
Comparing Evaluation Speed for Topological Data Analysis packages in R

## File Descriptions
Files with a name like `Circle_Time.R` or `Sphere_Time.R` are all similar in purpose. Each file contains:

1. A beginning section in which the user can test parameters to make sure both packages produce a similar looking diagram. This can also be used to get a sense of computation time or even memory use if something like task manager is open.

2. A main timing section to compare the two packages for various numbers of points. The main ways to mess with this section are:

+ If changing the number of iterations, be sure to change the length of the vectors initialized in the "Setting up Variables for Benchmarking" section and in the 'for' loop in the "Evaluation time for various numbers of smapled points" section

+ If changing how the point clouds will vary between iterations, be sure to change the formula both in the `[shape]Unif` command and (for purposes of labeling on the graph) immediately following that line in the "points" variables of the various data frames. 

+ If you aren't testing all of the packages/libraries there are several places to comment out. Commenting out any line after the "Setting up Variables for Benchmarking" section that has any reference to "Ripser", "Dion", or "GUD" should do it, but make sure also that in the "Everything into one data frame" section the `rbind` command is set to combine all the data frames and only the data frames you need. For example, if only comparing Ripser and GUDHI make sure the line is something like `Sphere.benchmarks <- rbind(ripser,GUD)`

The two files `Circle_Time_Zoom.R`, `Torus_Time_Zoom.R` look with high resolution (i.e. intervals of 1 point between iterations) at low numbers of points. This is where the interesting differences are, and we think this has to do with the slowdown at the beginning and end in R. 

Finally `Sphere_Dimensions.R` looks for the difference in evaluation speed for a fixed number of points but varying max dimension for which to calculate barcodes. 