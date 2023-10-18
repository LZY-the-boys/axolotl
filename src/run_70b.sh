#!/bin/bash
# set -e pipefail
export XDG_CACHE_HOME=/data/.cache
yaml_file="../examples/llama-2/gptq-lora-70b.yml"
# yaml_file="/home/lzy/axolotl/examples/llama-2/qlora.yml"
dir=/home/ubuntu/lzy/exp-data  
source activate lla
#source ~/lzy/submit/4090/excute.sh

new_data=arb_mcat
echo "use $new_data.json, output in $name"  
#escape special characters

WANDB_NAME=qwen-$name \
CUDA_VISIBLE_DEVICES=4 \
accelerate launch -m axolotl.cli.train $yaml_file \
--output_dir /data/outs/70b_lora/70b-$new_data.json \
--num_epochs 3 \

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
#         CUDA_VISIBLE_DEVICES=1,2,3,4,6,7 \
#         accelerate launch -m axolotl.cli.train $yaml_file \
#         --output_dir /data/outs/70b_lora/70b-$name \
#         --num_epochs 3
#     fi
# done