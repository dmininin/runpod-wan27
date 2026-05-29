#!/bin/bash

MODEL_DIR="/comfyui/models/diffusion_models"
TEXT_ENCODER_DIR="/comfyui/models/text_encoders"
VAE_DIR="/comfyui/models/vae"

mkdir -p $MODEL_DIR $TEXT_ENCODER_DIR $VAE_DIR

# Wan 2.2 T2V FP8 моделі
if [ ! -f "$MODEL_DIR/wan2.2_t2v_high_noise_14B_fp8_scaled.safetensors" ]; then
    echo "Downloading high noise model..."
    wget -q -O "$MODEL_DIR/wan2.2_t2v_high_noise_14B_fp8_scaled.safetensors" \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_t2v_high_noise_14B_fp8_scaled.safetensors"
fi

if [ ! -f "$MODEL_DIR/wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors" ]; then
    echo "Downloading low noise model..."
    wget -q -O "$MODEL_DIR/wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors" \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors"
fi

# Запускаємо ComfyUI в фоні
python /comfyui/main.py --listen 127.0.0.1 --port 8188 &

# Запускаємо handler
exec python -u /handler.py
