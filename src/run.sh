#!/bin/bash
# set -e pipefail
source activate lla
cd $home/axolotl/src

function train() {

: ${CUDA_VISIBLE_DEVICES:=7}

# $(echo "$input" | awk -F'[/;]' '{print $2}')
echo ">>> train $data_path, "
data_name=$(echo "$data_path" | cut -d';' -f1 | rev | cut -d'/' -f1 | rev | cut -d'.' -f1)

if [ "$size" -eq 7 ]; then
    LLAMA=meta-llama/Llama-2-7b-hf
elif [ "$size" -eq 13 ]; then
    LLAMA=meta-llama/Llama-2-13b-hf
elif [ "$size" -eq 70 ]; then
    LLAMA=meta-llama/Llama-2-70b-hf
else
    echo "Invalid size: $size"
    exit 1
fi
yaml_file="../examples/llama-2/qlora.yml"  
outs=$OUT_ROOT/$(basename $LLAMA)
echo ">>> output in $outs/llama-$data_name"

start_time=$(date +%s)

CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES \
LOG_FILE=$outs/llama-$data_name/log \
accelerate launch --main_process_port $(shuf -i25000-30000 -n1) -m axolotl.cli.train $yaml_file \
--datasets $data_path \
--base_model $LLAMA \
--base_model_config $LLAMA \
--dataset_prepared_path $outs/.dataset_cache \
--sequence_len 8192 \
--micro_batch_size 1 \
--output_dir $outs/llama-$data_name \
--num_epochs 3 

end_time=$(date +%s)
runtime=$((end_time - start_time))
runtime_minutes=$((runtime / 60))
echo "$data_name:  sec: $runtime ;min: $runtime_minutes" >> time.txt

}

function train_dir() {
    dir="$1"

    for file in "$dir"/*; do
        if [[ $file == *.json* ]]; then
            train "$file"
        fi
    done
}

train "$@" || read