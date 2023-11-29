#!/bin/bash
# set -e pipefail
source activate lla
cd $home/axolotl/src

function train() {
data_path=$1
yaml_file="../examples/llama-2/qlora.yml"  

: ${CUDA_VISIBLE_DEVICES:=7}

# $(echo "$input" | awk -F'[/;]' '{print $2}')
echo ">>> train $data_path, "
data_name=$(echo "$data_path" | cut -d';' -f1 | rev | cut -d'/' -f1 | rev | cut -d'.' -f1)

outs=$OUT_ROOT/llama-70b/llama-$data_name
echo ">>> output in $outs"

start_time=$(date +%s)

CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES \
LOG_FILE=$outs/log \
accelerate launch --main_process_port $(shuf -i25000-30000 -n1) -m axolotl.cli.train $yaml_file \
--datasets $data_path \
--base_model $LLAMA70B \
--base_model_config $LLAMA70B \
--dataset_prepared_path $OUT_ROOT/llama-70b/.dataset_cache \
--sequence_len 8192 \
--micro_batch_size 1 \
--output_dir $outs \
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