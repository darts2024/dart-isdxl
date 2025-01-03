import torch

from .config import model_name, load_model

# inits cpu and is expensive fails: in github actions
pipe = load_model(model_name)

# pipe.save_pretrained(model_path)

# from huggingface_hub import snapshot_download

# from config import model_name, model_path

# snapshot_download(repo_id=model_name, cache_dir=model_path, local_dir=model_path)

# print(f"Model files downloaded to: {model_path}")
