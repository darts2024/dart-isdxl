
from pathlib import Path
from typing import Final

import os

model_name:Final[str] = "runwayml/stable-diffusion-v1-5"
model_name:Final[str] = "stabilityai/stable-diffusion-xl-base-1.0"

base_model_dir = "./models"


def get_model_path(model_name: str)->str:
    # Create target directory based on model name
    model_dir = os.path.join(base_model_dir,model_name.replace("/", "_"))
    
    return model_dir
  
  
model_path = get_model_path(model_name)

print(f"Model path: {model_path}")