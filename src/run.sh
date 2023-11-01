
source activate lla
dir=/home/lzy/nips/data/exp-chat/three_class
yaml_file="../examples/llama-2/qwen.yml" 
# for file in "$dir"/*; do
#     if [ -f "$file" ] ; then
        file=/home/lzy/nips/data/platypus/bigbench-chat/chat4.json

        start_time=$(date +%s)

        new_data=$file
        name="${file##*/}"
        name="${name%.json}"
        echo "use $new_data, output in $name"  

        WANDB_NAME=qwen-$name \
        CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
        accelerate launch -m axolotl.cli.train $yaml_file \
        --datasets "$file;sharegpt:chat" \
        --output_dir ./outs/chat/three_class/qwen-$name \
        --num_epochs 3 \
        --trust_remote_code True 

        end_time=$(date +%s)
        runtime=$((end_time - start_time))
        runtime_minutes=$((runtime / 60))

        echo "$file:  sec: $runtime ;min: $runtime_minutes" >> time.txt
    
#     fi
# done