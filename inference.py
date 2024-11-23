import os
import torch

import numpy as np
import random
import logging

os.environ["CUBLAS_WORKSPACE_CONFIG"] = ":16:8"

torch.backends.cudnn.benchmark = False
# torch.use_deterministic_algorithms(True)

import torch
from diffusers import StableDiffusionPipeline


model_name = "runwayml/stable-diffusion-v1-5"

# load the Stable Diffusion model
pipe = StableDiffusionPipeline.from_pretrained(model_name, 
                                               revision="fp16", 
                                               torch_dtype=torch.float16)


# xpu: Intel
# cpu: CPU
# cuda: nvidia
# mps: mac meta

device = os.getenv("DEVICE", "xpu")

print("Device is",device)

if device == "xpu":
    import intel_extension_for_pytorch as ipex
    
    try:
        print(ipex.xpu.get_device_name(0))
    except Exception as e:
        logging.exception(e)

pipe = pipe.to(device)


prompt = os.getenv("PROMPT", "A futuristic cityscape at sunset")



# def set_seed(seed: int = 42) -> None:
#     np.random.seed(seed)
#     random.seed(seed)
#     torch.manual_seed(seed)
#     torch.cuda.manual_seed(seed)
#     # When running on the CuDNN backend, two further options must be set
#     torch.backends.cudnn.deterministic = True
#     torch.backends.cudnn.benchmark = False
#     # Set a fixed value for the hash seed
#     os.environ["PYTHONHASHSEED"] = str(seed)
#     print(f"Random seed set as {seed}")

# seed = int(os.getenv("RANDOM_SEED", "42"))
# set_seed(seed)


# g = torch.Generator(device="cuda")
# g.manual_seed(seed)

# For low GPU memory:
#pipe.enable_model_cpu_offload()

# To compile graph, but seems to be slower. Maybe the compiled graph isn't getting cached?
#pipe.unet = torch.compile(pipe.unet, mode="reduce-overhead", fullgraph=True)


# images = pipe(prompt=prompt, generator=g).images
images = pipe(prompt=prompt).images
print(f"Got {len(images)} images")


# OUTPUT_DIR must have a trailing slash

outputDir = os.getenv("OUTPUT_DIR", "")

for i in range(len(images)):
    image = images[i]
    image.save(outputDir + f"image-{i}.png")
