from diffusers import  DiffusionPipeline
import torch

model_name = "runwayml/stable-diffusion-v1-5"
# pipeline = StableDiffusionPipeline.from_pretrained(model_name,
#
#                                                    )

DiffusionPipeline.from_pretrained(model_name)


# pipeline.save_pretrained("./stable-diffusion-v1-5")