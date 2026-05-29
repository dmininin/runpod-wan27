#!/bin/bash
MODEL_DIR="/comfyui/models/diffusion_models"
mkdir -p $MODEL_DIR

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

exec python -u /handler.py
