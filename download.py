from diffusers import StableDiffusionPipeline
import torch

model_name:str = "runwayml/stable-diffusion-v1-5"
pipeline = StableDiffusionPipeline.from_pretrained(model_name)


# DiffusionPipeline.from_pretrained(model_name)


# pipeline.save_pretrained("./stable-diffusion-v1-5")