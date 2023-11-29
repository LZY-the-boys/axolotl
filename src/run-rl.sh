source activate lla
cd $LZY_HOME/cciipgpt/axolotl/src/
yaml_file="../examples/mistral/dpo.yml" 
file="HuggingFaceH4/ultrafeedback_binarized"
start_time=$(date +%s)

new_data=$file
name="${file##*/}"
name="${name%.json}"
echo "use $new_data, output in $name"  

WANDB_NAME=mistral-rl-$name \
LOG_FILE=$LZY_HOME/cciipgpt/mistral-rl-$name.log \
accelerate launch --main_process_port 29501 -m axolotl.cli.train $yaml_file \
--output_dir $LZY_HOME/cciipgpt/mistral-rl-$name \
--num_epochs 3 \
--micro_batch_size 1 \
--rl \
--trust_remote_code True \
--train_on_split train_prefs

end_time=$(date +%s)
runtime=$((end_time - start_time))
runtime_minutes=$((runtime / 60))

echo "$file:  sec: $runtime ;min: $runtime_minutes" >> time.txt