FROM runpod/worker-comfyui:latest

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
