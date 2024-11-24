# SDXL v0.9 in Docker 🐋

```
export HUGGINGFACE_TOKEN=<my huggingface token>
```

```
docker build -t sdxl:v0.9 --build-arg HUGGINGFACE_TOKEN=$HUGGINGFACE_TOKEN .
```

```
mkdir -p outputs
```

```
docker run -ti --gpus all \
    -v $PWD/outputs:/outputs \
    -e OUTPUT_DIR=/outputs/ \
    -e PROMPT="an astronaut riding an orange horse" \
    sdxl:v0.9
```

Will overwrite `outputs/image0.png` each time.

### Dart

```
darts run sdxl:v0.3.0 -i Prompt="hiro saves the hive" -i Seed=16
```

Playground: for module: https://go.dev/play/p/ddNw8F2hFO8

```
docker run -it --rm \
 -v "$PWD":/workspace \
 -v /dev/dri/by-path:/dev/dri/by-path \
 --device /dev/dri \
 --privileged \
 --network=host \
 "isdxl:v7"
```
