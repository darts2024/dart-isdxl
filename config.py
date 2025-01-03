
from pathlib import Path
from typing import Final

import os

model_name:Final[str] = "runwayml/stable-diffusion-v1-5"
model_name:Final[str] = "stabilityai/stable-diffusion-xl-base-1.0"
model_name:Final[str] = "stabilityai/stable-diffusion-3-medium"
model_name:Final[str] = "stabilityai/stable-diffusion-3.5-large"
# model_name:Final[str] = "stabilityai/stable-diffusion-3.5-large-turbo"  #needs extra config

# deprecated:
base_model_dir:os.PathLike = "./models"


def get_model_path(model_name: str)->str:
    # Create target directory based on model name
    model_dir = os.path.join(base_model_dir,model_name.replace("/", "_"))
    
    return model_dir
  
  
# model_path= get_model_path(model_name)

# print(f"Model path: {model_path}")