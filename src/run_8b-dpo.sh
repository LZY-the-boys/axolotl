source activate vllm-lora

name=$(date +"%Y%m%d-%H%M")
yml=/home/LeiFeng/lzy/axolotl/examples/llama-3/fft-8b-dpo.yaml

mkdir -p "/data/llama3-$name"
cp $yml "/data/llama3-$name"

# buggy
function run_llama3(){

echo ">>> output in /data/llama3-$name"

# CUDA_LAUNCH_BLOCKING=1 \
LOG_FILE="/data/llama3-$name/train.log" \
CUDA_VISIBLE_DEVICES=0,1 \
accelerate launch --main_process_port $(shuf -i25000-30000 -n1) -m axolotl.cli.train $yml \
--base_model="/data/model/Llama-3-8b" \
--dataset_prepared_path=/data/tmp \
--wandb_name="llama3-$name" \
--output_dir="/data/llama3-$name" 

}


function run_qwen1_5(){

echo ">>> output in /data/qwen-$name"

# CUDA_LAUNCH_BLOCKING=1 \
LOG_FILE="/data/qwen-$name/train.log" \
CUDA_VISIBLE_DEVICES=0,1 \
accelerate launch --main_process_port $(shuf -i25000-30000 -n1) -m axolotl.cli.train /home/LeiFeng/lzy/axolotl/examples/qwen/qlora-dpo.yml \
--base_model="Qwen/Qwen1.5-7B" \
--dataset_prepared_path=/data/tmp \
--wandb_name="qwen-$name" \
--output_dir="/data/qwen-$name" 

}
# run_llama3
run_qwen1_5
# --lora_model_dir="/data/lora-out" \