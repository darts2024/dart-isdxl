
from pathlib import Path
from typing import Final


model_name:Final[str] = "runwayml/stable-diffusion-v1-5"
model_name:Final[str] = "stabilityai/stable-diffusion-xl-base-1.0"

base_model_dir = Path("./models")


def get_model_path(model_name: str):
    # Create target directory based on model name
    model_dir = base_model_dir / model_name.replace("/", "_")
    
    return model_dir
  
  
model_path = get_model_path(model_name)

print(f"Model path: {model_path}")