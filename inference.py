import os
import torch

import numpy as np
import random
import logging

os.environ["CUBLAS_WORKSPACE_CONFIG"] = ":16:8"

torch.backends.cudnn.benchmark = False
# torch.use_deterministic_algorithms(True)

from .config import model_name,load_model

import torch
from diffusers import DiffusionPipeline

def set_seed(seed: int = 42) -> None:
    np.random.seed(seed)
    random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed(seed)
    # When running on the CuDNN backend, two further options must be set
    torch.backends.cudnn.deterministic = True
    torch.backends.cudnn.benchmark = False
    # Set a fixed value for the hash seed
    os.environ["PYTHONHASHSEED"] = str(seed)
    print(f"Random seed set as {seed}")


# xpu: Intel
# cpu: CPU
# cuda: nvidia
# mps: mac meta

device = os.getenv("DEVICE", "xpu")
modelArgs = {
    "torch_dtype" : torch.float16
}

print("Device is",device)


match device:
    case "xpu":
        import intel_extension_for_pytorch as ipex
        
        try:
            print(ipex.xpu.get_device_name(0))
        except Exception as e:
            logging.exception(e)
        
#    case "xpu", "cuda":
        
    case "cpu":
        modelArgs["torch_dtype"] = None
        
        


pipe = load_model(model_name,**modelArgs)


pipe = pipe.to(device)


prompt = os.getenv("PROMPT", "cute rabbit in a spacesuit")

seed = int(os.getenv("RANDOM_SEED", "42"))
set_seed(seed)

g = torch.Generator(device=device)
g.manual_seed(seed)

num_images = int(os.getenv("NUM_IMAGES", "1"))
print("num images:", num_images)


# For low GPU memory:
#pipe.enable_model_cpu_offload()

# To compile graph, but seems to be slower. Maybe the compiled graph isn't getting cached?
#pipe.unet = torch.compile(pipe.unet, mode="reduce-overhead", fullgraph=True)


images = pipe(prompt=prompt, generator=g, num_images_per_prompt=num_images).images
# images = pipe(prompt=prompt).images
print(f"Got {len(images)} images")

image_format = os.getenv("IMAGE_FORMAT", "png").strip().lower()


# OUTPUT_DIR must have a trailing slash

outputDir = os.getenv("OUTPUT_DIR", "")

for i in range(len(images)):
    image = images[i]
    
    # keywords = [word for word in prompt.split() if len(word) > 3]
    
    MAX_LENGTH = 150 # 255 for 
    
    filename = prompt.replace(" ", "-").lower()
    
    # Truncate at the nearest full word
    if len(filename) > MAX_LENGTH:
        truncated = filename[:MAX_LENGTH]  # Initial truncation
        if "-" in truncated:
            filename = truncated[:truncated.rfind("-")]  # Find the last complete word
        else:
            filename = truncated
    
    if i!=0:
        filename = f"{filename}.{i}"
        
    outputImageFile = os.path.join(outputDir,f"{filename}.{image_format}")
    
    if image_format=="png":
        image.save(outputImageFile)
    else:
        image.save(outputImageFile,format=image_format.upper(), optimize=True)

    print(f"saved {filename} to {outputImageFile}")
