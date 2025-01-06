set shell := ["sh", "-c"]
set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]
#set allow-duplicate-recipe
set positional-arguments
set dotenv-filename := ".env"

b jobFile="job.json":
  #!/bin/bash
  rm -rf exitCode stderr stdout
  # cd outputs && rm -rf exitCode stderr stdout
  # cd data && rm -rf exitCode stderr stdout
  # cd ..
  rm -rf data && mkdir -p data

  jobId=$(b create --id-only {{jobFile}})
  echo "jobId is $jobId"
  b logs -f $jobId 
  b get --output-dir './data' $jobId
  cp data/outputs/* ./outputs/
  
b1 jobFile="job.json":
  rm -rf exitCode stderr stdout
  cd outputs && rm -rf exitCode stderr stdout
  cd data && rm -rf exitCode stderr stdout
  b create --download -f --output-dir './data' --wait {{jobFile}}
  mv data/*.png ./outputs

docker *ARGS:
  docker run -it --privileged {{ARGS}}

ghcr VERSION="v1.6.0":
  just docker ghcr.io/darts2024/isdxl:{{VERSION}}