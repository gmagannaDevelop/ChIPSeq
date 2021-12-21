#! /usr/bin/env Rscript --vanilla

# Bootstrap installation (load required package)
if (!require("bPeaks")){
    install.packages("bPeaks")
    library(bPeaks)
}

data(yeastCDS)

# parse command-line arguments
args <- commandArgs(trailingOnly=T)
# basic input-output parameters
workdir <- args[1]
IPfile <- args[2]
controlFile <- args[3]

# grid search paramaters
IPcoeff <- as.numeric(args[4])
controlCoeff <- as.numeric(args[5])
log2FC <- as.numeric(args[6])
averageQuantiles <- as.numeric(args[7])

setwd(workdir)

in_data <- dataReading(IPfile = IPfile, controlFile = controlFile)

bPeaksAnalysis(IPdata       = in_data$IPdata,
               controlData  = in_data$controlData,
               cdsPositions = yeastCDS$Saccharomyces.cerevisiae,
               promSize     = 800, 
               IPcoeff      = IPcoeff, 
               controlCoeff = controlCoeff,
               log2FC       = log2FC, 
               averageQuantiles = averageQuantiles,
               peakDrawing  = FALSE)



