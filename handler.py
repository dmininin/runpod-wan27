import runpod
import subprocess
import requests
import json
import time
import os
import base64

COMFYUI_URL = "http://127.0.0.1:8188"

def wait_for_comfyui():
    for _ in range(60):
        try:
            r = requests.get(f"{COMFYUI_URL}/system_stats", timeout=2)
            if r.status_code == 200:
                return True
        except:
            pass
        time.sleep(2)
    return False

def queue_workflow(workflow):
    r = requests.post(f"{COMFYUI_URL}/prompt", json={"prompt": workflow})
    return r.json()["prompt_id"]

def wait_for_result(prompt_id):
    while True:
        r = requests.get(f"{COMFYUI_URL}/history/{prompt_id}")
        history = r.json()
        if prompt_id in history:
            outputs = history[prompt_id]["outputs"]
            for node_id, node_output in outputs.items():
                if "videos" in node_output:
                    return node_output["videos"][0]["filename"]
        time.sleep(2)

def handler(job):
    input_data = job["input"]
    prompt = input_data.get("prompt", "a beautiful landscape")
    workflow = input_data.get("workflow", None)

    if not workflow:
        return {"error": "No workflow provided"}

    workflow_str = json.dumps(workflow)
    for key, val in workflow.items():
        if "text" in workflow[key].get("inputs", {}):
            workflow[key]["inputs"]["text"] = prompt

    if not wait_for_comfyui():
        return {"error": "ComfyUI not started"}

    prompt_id = queue_workflow(workflow)
    filename = wait_for_result(prompt_id)

    video_path = f"/comfyui/output/{filename}"
    with open(video_path, "rb") as f:
        video_b64 = base64.b64encode(f.read()).decode()

    return {"video_base64": video_b64, "filename": filename}

runpod.serverless.start({"handler": handler})
