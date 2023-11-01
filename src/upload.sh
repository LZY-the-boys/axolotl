# huggingface-cli repo create qwen-bbq -y
# huggingface-cli repo create qwen-cnn -y
# huggingface-cli repo create qwen-guanaco -y
# 在setting里边手动make private
# huggingface-cli upload lu-vae/qwen-dolly /home/lzy/axolotl/src/outs/qwen-dolly/adapter_config.json adapter_config.json
# huggingface-cli upload lu-vae/qwen-dolly /home/lzy/axolotl/src/outs/qwen-dolly/adapter_model.bin adapter_model.bin
# huggingface-cli upload lu-vae/qwen-cnn /home/lzy/axolotl/src/outs/qwen-cnn-6w-32bit/adapter_config.json adapter_config.json
# huggingface-cli upload lu-vae/qwen-cnn /home/lzy/axolotl/src/outs/qwen-cnn-6w-32bit/adapter_model.bin adapter_model.bin
# huggingface-cli upload lu-vae/qwen-guanaco /home/lzy/axolotl/src/outs/qwen-guanaco/adapter_config.json adapter_config.json
# huggingface-cli upload lu-vae/qwen-guanaco /home/lzy/axolotl/src/outs/qwen-guanaco/adapter_model.bin adapter_model.bin
huggingface-cli upload --private lu-vae/qwen-chat2 /home/lzy/axolotl/src/outs/chat/three_class/qwen-chat4/adapter_config.json adapter_config.json
huggingface-cli upload --private lu-vae/qwen-chat2 /home/lzy/axolotl/src/outs/chat/three_class/qwen-chat4/adapter_model.bin adapter_model.bin
#  huggingface-cli repo create Miracle-Conversation --type dataset -y
#  huggingface-cli upload --repo-type dataset lu-vae/Miracle-Conversation dialogue_a.raw.jsonl