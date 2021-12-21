
# informative file, no execution
echo "Call the 'runall_bpeaks.fish' using gnu parallel as follows:"
echo "parallel -j14 -a runall_bpeaks.fish"
echo "adjust the -j parameter to match the desired number of parallel processes"
echo "WARNING : -j must not exceed the number of available cores on your machine"
echo "WARNING : each parallel process will consume ~1.5 GB of RAM"
echo "make sure you have enough memory to perform the parallel call"