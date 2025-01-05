# Use official Python 3.13 slim image as base
FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
# COPY . /app

# Install PyTorch with CUDA support (if needed)
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Install Jupyter Notebook dependencies
RUN pip install jupyter notebook ipykernel

# Set environment variables needed by DiffusionPipeline
ENV HF_HOME=/app/huggingface_home
ENV HUGGINGFACE_TOKEN='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'
ENV HF_TOKEN='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'


ENV XDG_CACHE_HOME=/app/.cache

# Install additional dependencies for DiffusionPipeline
RUN pip install accelerate transformers datasets diffusers

# Install IPython kernel for Jupyter Notebook
RUN python -m ipykernel install --user --name=python3.13

# Command to run the script
CMD ["jupyter", "notebook", "--allow-root", "--ip", "0.0.0.0", "--port", "9999"]
