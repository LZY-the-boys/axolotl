#!/bin/bash
# set -e pipefail
export XDG_CACHE_HOME=/data/.cache
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

# for file in "$dir"/*; do
#     if [ -f "$file" ] ; then

#         new_data=$file
#         name="${file##*/}"
#         name="${name%.json}"
#         echo "use $new_data, output in $name"  
#         # escape special characters
#         replacement=$(sed 's/[\/&]/\\&/g' <<< "$new_data")
#         sed -i "s/^  - path:.*/  - path: $replacement/g" "$yaml_file"

#         WANDB_NAME=qwen-$name \
#         CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
#         accelerate launch -m axolotl.cli.train $yaml_file \
#         --output_dir ./outs/qwen-$name \
#         --num_epochs 3 \
#         --trust_remote_code True 
#     fi
# done