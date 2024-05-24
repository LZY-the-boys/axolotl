source activate vllm-lora

# LOG_FILE=data_4_30.log \
# DEBUGDATA=1 \
# python -m axolotl.cli.preprocess /home/LeiFeng/lzy/axolotl/examples/qwen/qlora.yml \
# --dataset_processes=1 \
# --dataset_prepared_path=/data/tmp

# python -m axolotl.cli.preprocess /home/LeiFeng/lzy/axolotl/examples/qwen/qlora.yml \
# # --dataset_prepared_path=/data/tmp



LOG_FILE=train_qwen.log \
CUDA_VISIBLE_DEVICES=3 \
accelerate launch --main_process_port $(shuf -i25000-30000 -n1) -m axolotl.cli.train /home/LeiFeng/lzy/axolotl/examples/qwen/qlora3.yml \
--sequence_len=16384 \
--gradient_accumulation_steps=1 \
--base_model="Qwen/Qwen-14B" \
--dataset_prepared_path=/data/tmp \
--output_dir='/data/qwen-14-w1-truthfulqa' \
--trust_remote_code=True


LOG_FILE=train_qwen.log \
CUDA_VISIBLE_DEVICES=3,6 \
accelerate launch --main_process_port $(shuf -i25000-30000 -n1) -m axolotl.cli.train /home/LeiFeng/lzy/axolotl/examples/qwen/qlora3.yml \
--sequence_len=16384 \
--gradient_accumulation_steps=1 \
--base_model="Qwen/Qwen-14B" \
--dataset_prepared_path=/data/tmp \
--output_dir='/data/qwen-14-cproj-cnn' \
--trust_remote_code=True



LOG_FILE=train_qwen.log \
CUDA_VISIBLE_DEVICES=4,5,6,7 \
accelerate launch -m axolotl.cli.train /home/LeiFeng/lzy/axolotl/examples/qwen/fft2.yaml \
--sequence_len=16384 \
--gradient_accumulation_steps=1 \
--base_model="Qwen/Qwen-14B" \
--dataset_prepared_path=/data/tmp \
--output_dir='/data/qwen-fft-truthfulqa' \
--trust_remote_code=True

# --lora_model_dir="/data/lora-out" \



LOG_FILE=train_qwen.log \
CUDA_VISIBLE_DEVICES=0,1,2,3 \
accelerate launch --main_process_port $(shuf -i25000-30000 -n1) -m axolotl.cli.train /home/LeiFeng/lzy/axolotl/examples/qwen/qlora2.yml \
--sequence_len=8192 \
--gradient_accumulation_steps=1 \
--base_model="Qwen/Qwen-72B" \
--dataset_prepared_path=/data/tmp \
--output_dir='/data/qwen-72-lora-bbq' \
--trust_remote_code=True