import torch

model_name:str = "runwayml/stable-diffusion-v1-5"

try:
  from diffusers import StableDiffusionPipeline
  pipeline = StableDiffusionPipeline.from_pretrained(model_name, torch_dtype=torch.float16)
except:
  from diffusers import DiffusionPipeline
  DiffusionPipeline.from_pretrained(model_name,torch_dtype=torch.float16)


# pipeline.save_pretrained("./stable-diffusion-v1-5")