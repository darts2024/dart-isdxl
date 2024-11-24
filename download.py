import torch

model_name:str = "runwayml/stable-diffusion-v1-5"

try:
  from diffusers import StableDiffusionPipeline
  pipeline = StableDiffusionPipeline.from_pretrained(model_name)
except:
  from diffusers import DiffusionPipeline
  DiffusionPipeline.from_pretrained(model_name)


# pipeline.save_pretrained("./stable-diffusion-v1-5")