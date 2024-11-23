FROM intel/intel-extension-for-pytorch:2.1.40-xpu

ARG HUGGINGFACE_TOKEN='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'

RUN mkdir /app
WORKDIR /app

COPY *.py /app


RUN mkdir -p /inputs 
RUN mkdir -p /outputs


ADD requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt


ENV PIP_TIMEOUT=1000

RUN export DEBIAN_FRONTEND=noninteractive && \
    pip3 install huggingface_hub==0.16.4 

RUN huggingface-cli login --token $HUGGINGFACE_TOKEN ||  echo "huggingface login failed"
# python3 -c 'from diffusers import DiffusionPipeline; import torch; DiffusionPipeline.from_pretrained("runwayml/stable-diffusion-v1-5", torch_dtype=torch.float16, use_safetensors=True, variant="fp16")' 



RUN python3 /app/download.py


RUN rm /root/.cache/huggingface/token

# TODO: cache:

ENV HF_DATASETS_OFFLINE=1 
ENV TRANSFORMERS_OFFLINE=1 
ENV RANDOM_SEED=40

ENV PROMPT='A futuristic cityscape at sunset'
ENV OUTPUT_DIR="/outputs/"

ENTRYPOINT ["python3", "/app/inference.py"]
