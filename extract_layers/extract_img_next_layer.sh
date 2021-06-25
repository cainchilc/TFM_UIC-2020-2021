
# EXECUTIONS example
# ./extract_img_next_layer.sh T_10M/list_T_10M_menor_10M_nextLayer_1 T_10M 4
# ./extract_img_next_layer.sh TN_10M/list_TN_10M_menor_10M_nextLayer_1 TN_10M 4
# ./extract_img_next_layer.sh N_10M/list_N_10M_menor_10M_nextLayer_1 N_10M 4


# input
file_nextLayer=$1  # list_T_10M_menor_10M_nextLayer_1 ==> MANDATORI
out_dir=$2         # T_10M / TN_10M / N_10M
threads=$3;        # number threads

in_dir=`echo $out_dir | cut -d'_' -f1`
dir_samples="/home/jovyan/images/$in_dir"

iteration_layer=`echo $file_nextLayer | sed 's/.*_//g'` 
cmd_file="resolution_aprox10M_${in_dir}_cmd_NextLayer_${iteration_layer}"

##############################################################
# Getting file name and layer for Preparing cmd with nextLayer

echo -e "\nPreparing commands NextLayer..."

for line in `cat $file_nextLayer`; do name=`echo $line | cut -d'_' -f1`; layer=`echo $line | cut -d'_' -f2 | cut -d'.' -f1`; nextLayer=`expr $layer - 1`; echo "convert $dir_samples/$name.tif[$nextLayer] $out_dir/${name}_$nextLayer.png"; done > $cmd_file

echo -e "Comands DONE!\n"



#############################################
# PARALLEL execution

echo -n -e "\n\nDATE: extracting Images "; date
echo ""

count=1;
tmp_basename=`basename $file_nextLayer`
tmp_file="tmp_file_${tmp_basename}"
rm $tmp_file
PID_LIST=""
cat $cmd_file | while read line; do 
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