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

# move into the isolated directory, to avoid
# overwritting bPeaks' output (bPeaks_bPeaks_parameterSummary.txt)
setwd(workdir)

# Read IP and control data 
in_data <- dataReading(IPfile = IPfile, controlFile = controlFile)

# launch a single bPeaksAnalysis call, with a single set of parameters
# (the grid will be evaluated in parallel from the shell, not sequentially within R)
bPeaksAnalysis(IPdata       = in_data$IPdata,
               controlData  = in_data$controlData,
               cdsPositions = yeastCDS$Saccharomyces.cerevisiae,
               promSize     = 800, 
               IPcoeff      = IPcoeff, 
               controlCoeff = controlCoeff,
               log2FC       = log2FC, 
               averageQuantiles = averageQuantiles,
               peakDrawing  = FALSE)



