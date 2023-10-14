#!/bin/bash
set -e pipefail
yaml_file="/home/lzy/axolotl/examples/mistral/qlora.yml"
dir="/home/lzy/nips/data/exp"  # Replace with the path to your directory
source activate lla
for file in "$dir"/*; do
    if [ -f "$file" ] ; then

        new_data=$file
        name="${file##*/}"
        name="${name%.json}"
        echo "use $new_data, output in $name"  
        # escape special characters
        replacement=$(sed 's/[\/&]/\\&/g' <<< "$new_data")
        sed -i "s/^  - path:.*/  - path: $replacement/g" "$yaml_file"

        WANDB_NAME=mistral-$name \
        CUDA_VISIBLE_DEVICES=1,3 \
        accelerate launch -m axolotl.cli.train ../examples/mistral/qlora.yml \
        --output_dir ./outs/mistral-$name-adamw32 \
        --num_epochs 3
    fi
done
