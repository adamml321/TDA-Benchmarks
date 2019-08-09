#Memory profiling of the TDA and TDAstats packages

#This file requires the jointprof package https://github.com/r-prof/jointprof
#For this reason, it only works on Ubuntu and OS X

library(TDA)
library(TDAstats)
library(bench)
library(ggplot2)
library(jointprof)
library(prof.tree)
library(proftools)
library(profvis)

#Declare point cloud
test_sphere <- torusUnif(20 ,2 ,r=1)

target_file <- "sph_ripserprof.out"

# Collect profile data
start_profiler(target_file)

## code to be profiled
test.phom.TDAstat <- calculate_homology(test_sphere,dim=2)
plot_barcode(test.phom.TDAstat)


stop_profiler()

# Analyze profile data
summaryRprof(target_file)
profvis::profvis(prof_input = target_file)
proftools::readProfileData(target_file)
prof.tree::prof.tree(target_file)

# Convert to pprof format and analyze
pprof_target_file <- "ripserprof.pb.gz"
profile_data <- profile::read_rprof(target_file)
profile::write_rprof(profile_data, pprof_target_file)
system2(
  find_pprof(),
  c(
    "-http",
    "localhost:8080",
    shQuote(pprof_target_file)
  )
)