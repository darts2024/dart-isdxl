import torch

from config import model_name

try:
  from diffusers import DiffusionPipeline
  DiffusionPipeline.from_pretrained(model_name)
except:
  from diffusers import StableDiffusionPipeline
  pipeline = StableDiffusionPipeline.from_pretrained(model_name)


# pipeline.save_pretrained("./stable-diffusion-v1-5")