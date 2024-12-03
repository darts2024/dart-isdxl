FROM python:3.12-slim as downloader

ARG HUGGINGFACE_TOKEN='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'

RUN pip install --no-cache-dir huggingface_hub==0.16.4 

WORKDIR /app
COPY *.py /app

ADD requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

# Login to HuggingFace and download model
RUN huggingface-cli login --token $HUGGINGFACE_TOKEN || echo "huggingface login failed"
RUN python3 download.py


FROM intel/intel-extension-for-pytorch:2.1.40-xpu

RUN mkdir /app
WORKDIR /app

COPY *.py /app


RUN mkdir -p /inputs 
RUN mkdir -p /outputs


ADD requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt


ENV PIP_TIMEOUT=1000

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && apt-get install -y libjpeg-dev libpng-dev libgl1-mesa-glx libglib2.0-0 

# python3 -c 'from diffusers import DiffusionPipeline; import torch; DiffusionPipeline.from_pretrained("runwayml/stable-diffusion-v1-5", torch_dtype=torch.float16, use_safetensors=True, variant="fp16")' 

COPY --from=downloader /app/models /app/models


ENV HF_DATASETS_OFFLINE=1 
ENV TRANSFORMERS_OFFLINE=1 
ENV RANDOM_SEED=40

ENV PROMPT='a cat sitting on a park bench'
ENV OUTPUT_DIR="/outputs/"
ENV DEVICE="xpu"

# optimization

ENV PYTORCH_JIT_LOG_LEVEL=ERROR
ENV PYTORCH_JIT_OPTIMIZE=1

# preload a torch backend for the device
RUN python3 -c "import torch; torch.ones(1).to('cpu')"
RUN python3 -c "import torch; torch.ones(1).to('xpu')" || echo "Fialed to load xpu"

RUN python3 -m compileall $(python3 -c "import torch; import os; print(os.path.dirname(torch.__file__))")


RUN python3 -m compileall $(python3 -c "import site; print(site.getsitepackages()[0])")

RUN python3 -m compileall /app/inference.py


ENTRYPOINT ["python3", "/app/inference.py"]
