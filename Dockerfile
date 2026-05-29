FROM runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04

RUN pip install runpod requests

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
