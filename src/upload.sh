# https://github.com/huggingface/hf_transfer
# use  write token to login 
# huggingface-cli upload lu-vae/mistral-guanaco-lima-dolly outs/mistral-guanaco-lima-dolly/adapter_config.json adapter_config.json
# huggingface-cli upload lu-vae/mistral-guanaco-lima-dolly outs/mistral-guanaco-lima-dolly/adapter_model.bin adapter_model.bin
huggingface-cli repo create qwen-dolly -y
huggingface-cli repo create qwen-cnn -y
huggingface-cli repo create qwen-guanaco -y
# 在setting里边手动make private
huggingface-cli upload lu-vae/qwen-dolly /home/lzy/axolotl/src/outs/qwen-dolly/adapter_config.json adapter_config.json
huggingface-cli upload lu-vae/qwen-dolly /home/lzy/axolotl/src/outs/qwen-dolly/adapter_model.bin adapter_model.bin
huggingface-cli upload lu-vae/qwen-cnn /home/lzy/axolotl/src/outs/qwen-cnn-6w-32bit/adapter_config.json adapter_config.json
huggingface-cli upload lu-vae/qwen-cnn /home/lzy/axolotl/src/outs/qwen-cnn-6w-32bit/adapter_model.bin adapter_model.bin
huggingface-cli upload lu-vae/qwen-guanaco /home/lzy/axolotl/src/outs/qwen-guanaco/adapter_config.json adapter_config.json
huggingface-cli upload lu-vae/qwen-guanaco /home/lzy/axolotl/src/outs/qwen-guanaco/adapter_model.bin adapter_model.bin