
function parallel_bpeaks
    # Check number of arguments, we expect two :
    # 'params.fish' -> a file containing necessary parameters
    # 'experimentDir' -> a directory name to isolate bPeak's output
    if test (count $argv) -ne 2
        echo parallel_bpeaks
        echo \nusage:
        echo \$ parallel_bpeaks params.fish experimentDir \n
        echo "where 'params.fish' is a fish script defining the following parameters:"
        echo \t\* IPcoeff
        echo \t\* controlCoeff
        echo \t\* log2FC
        echo \t\* averageQuantiles 
        echo \t\* IPfile \(fullpath\)
        echo \t\* controlFile \(fullpath\)
        echo \t\* rScript \(fullpath\) \n
        echo "and 'experimentDir' is the name of a directory (to be created) to store"
        echo "all the simulations results."

    else
        set --path paramsFile $argv[1]
        set --path outDir $argv[2]
        # check that outDir does not exist and paramsFile exists
        if not test -d $outDir; and test -f $paramsFile
            mkdir $outDir
            # get parameters from our paramsFile
            source $paramsFile
            # create script
            set --path outScript $outDir/runall_bpeaks.fish
            set --path gatherScript $outDir/gather_results.fish
            #touch $outScript            
            set param_grid $IPcoeff\_$controlCoeff\_$log2FC\_$averageQuantiles
            # Create scripts containing all different param combinations
            for param in $param_grid
                # bPeaks finding script
                echo "mkdir $param;" Rscript $rScript $param $IPfile $controlFile (string split '_' $param) >> $outScript
                # data gathering script
                echo "cat $param/bPeaks_bPeaks_parameterSummary.txt >> gathered.txt" >> $gatherScript
            end
            # remove redundant lines (duplicate headers)
            echo "awk '!a[\$0]++' gathered.txt >> results.txt" >> $gatherScript
                        
        # if passed parameters are invalid, display an error message
        else
            echo ERROR, check parameters
            echo "is '$paramsFile' a regular file, containing the parameter grid?"
            echo "directory '$outDir' should not exist, the script will create it"
        end
    end
end