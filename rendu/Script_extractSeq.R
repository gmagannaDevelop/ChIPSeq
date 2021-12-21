# Gaëlle Lelandais <gaelle.lelandais@universite-paris-saclay.fr>

# Fichier BED (sortie de bPeaks), avec les coordonnées des pics
# pour lesquels les séquences doivent être récupérées.
BEDname = "bPeaks_bPeaks_allGenome.bed"

# Début du programme ... 
bedFile = read.table(BEDname)

library(seqinr)
# Sequences des chromosomes
genomeSeq = read.fasta(file = "cerevisiae/genome_cerevisiae_SGD.fasta")

listSeq   = NULL
listNames = NULL

# Pour chaque pics
for(i in 1:nrow(bedFile)){

  # nom du chromose
  chrom = bedFile[i,1]
  # récupération de la séquence
  seq  = paste0(getSequence(genomeSeq)[[which(getAnnot(genomeSeq) == paste0(">", chrom))]][bedFile[i,2]:bedFile[i,3]], collapse = "")
  # création d'un nom pour le fichier FASTA
  name = paste(as.character(bedFile[i,4]), chrom, "from:", bedFile[i,2], "to:", bedFile[i,3])  
  
  # Ajout aux listes
  listSeq = c(listSeq, list(seq))
  listNames = c(listNames, list(name))
}

# Ecriture du fichier FASTA
write.fasta(listSeq, listNames, paste0(BEDname, "_seq.fasta"), nbchar = 20)
