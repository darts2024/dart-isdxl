import torch

from config import model_name, model_path

pipe = None

try:
  from diffusers import DiffusionPipeline
  pipe = DiffusionPipeline.from_pretrained(model_name)
except:
  from diffusers import StableDiffusionPipeline
  pipe = StableDiffusionPipeline.from_pretrained(model_name)


pipe.save_pretrained(model_path)