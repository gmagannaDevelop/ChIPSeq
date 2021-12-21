# ChIPSeq
Projet Final UE Analyse Statistique de Données *Omiques


## Running bpeaks in parallel
```bash
fish # activate the fish shell (instead of bash)
cd rendu/
source parallel_bpeaks.fish # source the file to access the function defined within
# WARNING : you must change the path found in params.fish !
# the path to the working directory is hardcoded !
parallel_bpeaks params.fish example2 
# ^ this instruction will create a directory called example2/
# example2/ wil contain the necessary scripts to perform the parallel call (see example/)
cd example2
parallel -j8 -a runall_bpeaks.fish # run bpeaks in parallel, using 8 threads
source gather_results.fish # gather all parameter summaries from child directories
ls 
# you should now see a file called results.txt
```
