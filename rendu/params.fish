# Necessary paths to find scripts
# change 'baseDir' to /repos/location/on/your/machine/**rendu**
set --path baseDir /home/gml/Documents/Master/M2_AMI2B/Omiques/projet/rendu
set --path rScript $baseDir/runbpeaks.R
set --path IPfile $baseDir/IP_genomeCoverage.txt 
set --path controlFile $baseDir/INPUT_genomeCoverage.txt

# first set
# values for each parameter should be specified
# as a list, separated only by a blank space
set IPcoeff 4 
set controlCoeff 4
set log2FC 3 3.25 3.5 3.75 4 4.25 
set averageQuantiles 0.9
