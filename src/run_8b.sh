source activate vllm-lora

# LOG_FILE=data_4_30.log \
# DEBUGDATA=1 \
# python -m axolotl.cli.preprocess /home/LeiFeng/lzy/axolotl/examples/llama-3/qlora.yml \
# --dataset_processes=1 \
# --dataset_prepared_path=/data/tmp
name=$(date +"%Y%m%d-%H%M")

function run_lora(){

LOG_FILE="/data/llama3-$name/train.log" \
CUDA_VISIBLE_DEVICES=4,5,6 \
accelerate launch --main_process_port $(shuf -i25000-30000 -n1) -m axolotl.cli.train /home/LeiFeng/lzy/axolotl/examples/llama-3/qlora.yml \
--base_model="/data/model/Llama-3-8b" \
--dataset_prepared_path=/data/tmp \
--output_dir="/data/llama3-$name"

}

# buggy
function run_fft(){

yml=/home/LeiFeng/lzy/axolotl/examples/llama-3/fft-8b.yaml

mkdir -p "/data/llama3-$name"
cp $yml "/data/llama3-$name"

echo ">>> output in /data/llama3-$name"

# CUDA_LAUNCH_BLOCKING=1 \
LOG_FILE="/data/llama3-$name/train.log" \
CUDA_VISIBLE_DEVICES=0,1,2,3,4,5 \
accelerate launch --main_process_port $(shuf -i25000-30000 -n1) -m axolotl.cli.train $yml \
--base_model="/data/model/Llama-3-8b" \
--dataset_prepared_path=/data/tmp \
--wandb_name="llama3-$name" \
--output_dir="/data/llama3-$name" \
--resume_from_checkpoint="/data/llama3-20240502-0354/checkpoint-374/"

# LOG_FILE="/data/llama3-$name/train.log" \
# python -m axolotl.cli.preprocess /home/LeiFeng/lzy/axolotl/examples/llama-3/qlora.yml \
# --dataset_processes=1 \
# --dataset_prepared_path=/data/llama3-$name

}

function run_qwen1_5(){

yml=/home/LeiFeng/lzy/axolotl/examples/qwen/fft.yaml

mkdir -p "/data/qwen-$name"
cp $yml "/data/qwen-$name"

echo ">>> output in /data/qwen-$name"

# CUDA_LAUNCH_BLOCKING=1 \
LOG_FILE="/data/qwen-$name/train.log" \
CUDA_VISIBLE_DEVICES=0,1,2,3,4,5 \
accelerate launch --main_process_port $(shuf -i25000-30000 -n1) -m axolotl.cli.train $yml \
--base_model="Qwen/Qwen1.5-7B" \
--dataset_prepared_path=/data/tmp \
--wandb_name="qwen-$name" \
--output_dir="/data/qwen-$name" \
--resume_from_checkpoint="/data/qwen-20240503-1634/checkpoint-3060" 

# LOG_FILE="/data/llama3-$name/train.log" \
# python -m axolotl.cli.preprocess /home/LeiFeng/lzy/axolotl/examples/llama-3/qlora.yml \
# --dataset_processes=1 \
# --dataset_prepared_path=/data/llama3-$name

}


function run_fft2(){

yml=/home/LeiFeng/lzy/axolotl/examples/llama-3/fft-8b.yaml

mkdir -p "/data/llama-68m-$name"
cp $yml "/data/llama-68m-$name"

echo ">>> output in /data/llama-68m-$name"

LOG_FILE="/data/llama-68m-$name/train.log" \
CUDA_VISIBLE_DEVICES=0,1,2,3,4,5 \
accelerate launch --main_process_port $(shuf -i25000-30000 -n1) -m axolotl.cli.train $yml \
--base_model="JackFram/llama-68m" \
--dataset_prepared_path=/data/tmp \
--saves_per_epoch=1 \
--output_dir="/data/llama-68m-$name"

}

# TinyLlama/tinyLlama-intermediate-checkpoints-after-1T-token
function run_fft3(){

name="20240502-0131"
yml=/home/LeiFeng/lzy/axolotl/examples/llama-3/fft-8b.yaml

mkdir -p "/data/llama-1B-$name"
cp $yml "/data/llama-1B-$name"

echo ">>> output in /data/llama-1B-$name"

LOG_FILE="/data/llama-1B-$name/train.log" \
CUDA_VISIBLE_DEVICES=6,7 \
accelerate launch --main_process_port $(shuf -i25000-30000 -n1) -m axolotl.cli.train $yml \
--base_model="TinyLlama/TinyLlama-1.1B-Chat-v1.0" \
--dataset_prepared_path=/data/tmp \
--wandb_name=llama-1B-$name \
--saves_per_epoch=1 \
--output_dir="/data/llama-1B-$name" \
--resume_from_checkpoint="/data/llama-1B-20240502-0131/checkpoint-1671"

}


run_qwen1_5
# --lora_model_dir="/data/lora-out" \