import torch

from config import model_name, model_path

# inits cpu and is expensive fails: in github actions
pipe = None

try:
  from diffusers import DiffusionPipeline
  pipe = DiffusionPipeline.from_pretrained(model_name)
except:
  from diffusers import StableDiffusionPipeline
  pipe = StableDiffusionPipeline.from_pretrained(model_name)


pipe.save_pretrained(model_path)

# from huggingface_hub import snapshot_download

# from config import model_name, model_path

# snapshot_download(repo_id=model_name, cache_dir=model_path, local_dir=model_path)

print(f"Model files downloaded to: {model_path}")
