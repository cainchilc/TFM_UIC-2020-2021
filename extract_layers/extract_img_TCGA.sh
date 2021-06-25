
# EXECUTIONS example
#time -p /home/jovyan/work/data/extract_layers/extract_img.sh TN 10 &> log_TN
#time -p /home/jovyan/work/data/extract_layers/extract_img.sh T 10 &> log_T
#time -p /home/jovyan/work/data/extract_layers/extract_img.sh N 10 &> log_N
#time -p /home/jovyan/work/data/extract_layers/extract_img.sh TCGA 10 &> log_TCGA


# input
dir_samples=$1 # TN / T ==> MANDATORI
threads=$2;    # number threads

#############################################
# Checking input arguments

# Checking if there is input argument 1
if [ -z "$1" ]; then
    threads=5;
    echo -e "\nImage folder name is needed (TN / T / N / TCGA)\n"
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

# img_path="/home/jovyan/images/${dir_samples}/*" # images from LA group
img_path="/home/jovyan/${dir_samples}"          # images from TCGA 

#resolution="[2-3][0-9][0-9][0-9]x" # images from LA group
resolution="[0-9][0-9][0-9][0-9]x" # images from TCGA 
# agafem la resolucio mes gran de les més petites (tail)
for i in `ls ${img_path}/*`; do identify $i | grep -P " $resolution" | sort -nk3 | tail -n1; done > resolution_aprox10M_${dir_samples}
echo -e "DONE!\n"

#resolution="[0-9][0-9][0-9][0-9][0-9]x" # images from TCGA 
# agafem la resolucio mes petita de les grans (head)
#for i in `ls ${img_path}/*`; do identify $i | grep -P " $resolution" | sort -nk3 | head -n1; done > resolution_aprox10M_${dir_samples}
#echo -e "DONE!\n"


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