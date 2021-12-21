
# Install BiocManager, an interface to BioConductor, 
# an R repository for biological software
if (!requireNamespace("BiocManager", quietly = TRUE)){
  install.packages("BiocManager")
}

# declare dependencies
.bioc.dependencies <- c(
  "ChIPpeakAnno",
  "GenomicFeatures",
  "TxDb.Scerevisiae.UCSC.sacCer3.sgdGene",
  "org.Sc.sgd.db",
  "org.Sc.sgd.db",
  "GO.db",
  "KEGG.db"
)

# load dependencies and install them if they are missing
suppressWarnings(
  .missing.deps <- 
    sapply(.bioc.dependencies, function(x){ !require(x, character.only = T)})
)
BiocManager::install(pkgs = names(Filter(function(x){x}, .missing.deps)))


library(ChIPpeakAnno)
library(GenomicFeatures)

# Our bPeaks
gr1 <- toGRanges("bPeaks_bPeaks_allGenome.bed", header=F, format="BED")
library(TxDb.Scerevisiae.UCSC.sacCer3.sgdGene)
# The reference genome
annoData <- toGRanges(TxDb.Scerevisiae.UCSC.sacCer3.sgdGene, feature="gene")

# Peak annotation using the peaks' positions found in gr1
# and the annotations found in annoData (S. cerevisiae ref. genome)
annotatedPeak <- annotatePeakInBatch(gr1,AnnotationData = annoData)
# A minimalistic visualisation of the types of peaks we found
pie1(table(annotatedPeak$insideFeature))

#Chargement de la libraire du génome de S.cerevisae
library(org.Sc.sgd.db)

# store peaks' indices found upstream (promoter region)
index <- which(annotatedPeak$insideFeature=="upstream")

library(GO.db) # Gene ontology annotation
over <- 
  getEnrichedGO(annotatedPeak[index], feature_id_type="entrez_id",
                orgAnn="org.Sc.sgd.db", maxP=0.05, minGOterm=5, condense=T)

# save biological process
write.csv(over$bp,"biologicalprocess.csv", row.names = FALSE) 
# save molecular function
write.csv(over$mf,"molecularfonction.csv", row.names = FALSE) 

