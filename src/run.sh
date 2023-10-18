#!/bin/bash
# set -e pipefail

yaml_file="../examples/llama-2/qwen.yml"
# yaml_file="/home/lzy/axolotl/examples/llama-2/qlora.yml"
dir=/home/ubuntu/lzy/exp-data  
source activate lla

name=qwen-mmlu
WANDB_NAME=qwen-$name \
CUDA_VISIBLE_DEVICES=1,2,3,5,6,7 \
accelerate launch -m axolotl.cli.train $yaml_file \
--output_dir ./outs/qwen-$name \
--num_epochs 3 \
--wandb_project nips-effiency \
--trust_remote_code True 

for file in "$dir"/*; do
    if [ -f "$file" ] ; then

        new_data=$file
        name="${file##*/}"
        if [ -z "$name" ]; then
            name=$file
        name="${name%.json}"
        echo "use $new_data, output in $name"  
        # escape special characters
        replacement=$(sed 's/[\/&]/\\&/g' <<< "$new_data")
        sed -i "s/^  - path:.*/  - path: $replacement/g" "$yaml_file"

        WANDB_NAME=mistral-$name \
        CUDA_VISIBLE_DEVICES=1,3 \
        accelerate launch -m axolotl.cli.train ../examples/mistral/qlora.yml \
        --output_dir ./outs/mistral-$name \
        --num_epochs 3
        
    fi
done
