# ISDXL : sdxl in intel

## Support

- cpu
- xpu (intel)
- gaudi (intel accelerator)
- nvidia

### Dart

```
darts run github.com/darts2024/dart-isdxl:v1.5.0 -i Prompt="cat sit on a trampoline" -i Device="xpu
"
```

### Dev Docs

Playground: for building the module: https://go.dev/play/p/ddNw8F2hFO8

```shell

docker run -it --rm \
 -v "$PWD"/data:/outputs \
 -v /dev/dri/by-path:/dev/dri/by-path \
 --device /dev/dri \
 --privileged \
 --network=host \
 "laciferin/isdxl:v0.0.8"

docker run -it --rm \
 -v "$PWD"/data:/outputs \
 --privileged \
 "laciferin/isdxl:v0.0.8"

```
