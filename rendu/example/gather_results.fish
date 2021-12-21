cat 4_4_3_0.9/bPeaks_bPeaks_parameterSummary.txt >> gathered.txt
cat 4_4_3.25_0.9/bPeaks_bPeaks_parameterSummary.txt >> gathered.txt
cat 4_4_3.5_0.9/bPeaks_bPeaks_parameterSummary.txt >> gathered.txt
cat 4_4_3.75_0.9/bPeaks_bPeaks_parameterSummary.txt >> gathered.txt
cat 4_4_4_0.9/bPeaks_bPeaks_parameterSummary.txt >> gathered.txt
cat 4_4_4.25_0.9/bPeaks_bPeaks_parameterSummary.txt >> gathered.txt
awk '!a[$0]++' gathered.txt >> results.txt
