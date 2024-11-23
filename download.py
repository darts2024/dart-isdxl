from diffusers import StableDiffusionPipeline, DiffusionPipeline
import torch

model_name = "runwayml/stable-diffusion-v1-5"
pipeline = StableDiffusionPipeline.from_pretrained(model_name,
                                                 # torch_dtype=torch.float16, use_safetensors=True, variant="fp16"
                                                   )

# DiffusionPipeline.from_pretrained(model_name, torch_dtype=torch.float16, use_safetensors=True, variant="fp16")


# pipeline.save_pretrained("./stable-diffusion-v1-5")