set --path baseDir /home/gml/Documents/Master/M2_AMI2B/Omiques/projet/rendu
set --path rScript $baseDir/runbpeaks.R
set --path IPfile $baseDir/IP_genomeCoverage.txt 
set --path controlFile $baseDir/INPUT_genomeCoverage.txt

# first set
set IPcoeff 4 
set controlCoeff 4
set log2FC 3 3.25 3.5 3.75 4 4.25 
set averageQuantiles 0.9

#set IPcoeff 6 4 
#set controlCoeff 4 6
#set log2FC 3 2 
#set averageQuantiles 0.9 0.7
