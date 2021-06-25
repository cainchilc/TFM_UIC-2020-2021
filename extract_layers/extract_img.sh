
# EXECUTIONS
#time -p ./extract_img.sh TN 10 &> log_TN
#time -p ./extract_img.sh T 10 &> log_T

# input
dir_samples=$1 # TN / T ==> MANDATORI
threads=$2;    # number threads


#############################################
# Checking input arguments

# Checking if there is input argument 1
if [ -z "$1" ]; then
    threads=5;
    echo -e "\nImage folder name is needed (TN / T)\n"
    exit -1
fi
# Checking if there is input argument 2
if [ -z "$2" ]; then
    threads=5;
fi
echo -e "\nNumber of threads = $threads\n"

out_dir="${dir_samples}_10M"
mkdir -p $out_dir # Creating dir


#############################################
# Getting ~10M resolutions from original files

echo -n -e "\nDATE get ALL resolutions: "; date
echo ""
echo -e "\nGetting ALL resolutions from original files..."
echo -e "\tFile: resolution_aprox10M_${dir_samples}"
for i in `ls /home/jovyan/images/${dir_samples}/*`; do identify $i | grep -P " [2-3][0-9][0-9][0-9]x"; done > resolution_aprox10M_${dir_samples}
echo -e "DONE!\n"


#######################################
# Preparing cmd with resolution ~ 10M

echo -n -e "\nDATE get 10M resolution: "; date
echo ""
echo -e "\nPreparing commands..."
echo -e "\tFile: resolution_aprox10M_${dir_samples}_cmd"
for i in `cat resolution_aprox10M_${dir_samples} | cut -d' ' -f1`; do id=`echo $i | sed 's/.*\[//g' | sed 's/\]//g'`; filename=`echo $(basename $i) | cut -d'.' -f1`; echo "convert $i $out_dir/${filename}_${id}.png"; done > resolution_aprox10M_${dir_samples}_cmd
echo -e "Comands DONE!\n"


#############################################
# PARALLEL execution

# TODO :: MIRAR :: PARALLEL execution
#    https://www.golinuxcloud.com/run-shell-scripts-in-parallel-collect-exit-status-process/
#    https://saveriomiroddi.github.io/Running-shell-commands-in-parallel-via-gnu-parallel/


echo -n -e "\n\nDATE: extracting Images "; date
echo ""

count=1;
tmp_file="tmp_file_${dir_samples}"
rm $tmp_file
PID_LIST=""
cat resolution_aprox10M_${dir_samples}_cmd | while read line; do 
    echo $line
    $line &
    PID="$!"
    echo "$PID" >> $tmp_file
    PID_LIST+="$PID ";

    if [ $count == $threads ]; then 
        count=1 
        echo "Waiting jobs IDs:"
        for wait_PID in `echo $PID_LIST`; do
            echo $wait_PID
            wait $wait_PID
        done
        PID_LIST=""
    else 
        count=`expr $count + 1`
    fi
done


echo -n -e "\nDATE: Images DONE! "; date
echo ""