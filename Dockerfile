FROM intel/intel-extension-for-pytorch:2.1.40-xpu

ARG HUGGINGFACE_TOKEN='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'

RUN mkdir /app
WORKDIR /app


RUN mkdir -p /inputs 
RUN mkdir -p /outputs


ADD requirements.txt /app/requirements.txt

ENV PIP_TIMEOUT=1000

RUN export DEBIAN_FRONTEND=noninteractive && \
    pip3 install huggingface_hub==0.16.4 && \
    huggingface-cli login --token $HUGGINGFACE_TOKEN && \
    python3 -c 'from diffusers import DiffusionPipeline; import torch; DiffusionPipeline.from_pretrained("runwayml/stable-diffusion-v1-5", torch_dtype=torch.float16, use_safetensors=True, variant="fp16")' 


RUN rm /root/.cache/huggingface/token

# TODO: cache:
# pipe.unet = torch.compile(pipe.unet, mode="reduce-overhead", fullgraph=True)

ENV HF_DATASETS_OFFLINE=1 
ENV TRANSFORMERS_OFFLINE=1 
ENV OUTPUT_DIR="/outputs/"
ENV RANDOM_SEED=40

ADD inference.py /app/inference.py
ENTRYPOINT ["python3", "/app/inference.py"]
