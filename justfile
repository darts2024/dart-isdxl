set shell := ["sh", "-c"]
set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]
#set allow-duplicate-recipe
set positional-arguments
set dotenv-filename := ".env"

b jobFile="job.json":
  #!/bin/bash
  rm -rf exitCode stderr stdout
  # cd outputs && rm -rf exitCode stderr stdout
  cd data && rm -rf exitCode stderr stdout
  cd ..
  jobId=$(b create {{jobFile}})
  echo "jobId is $jobId"
  b logs -f $jobId 
  b get --output-dir './data' $jobId
  mv data/*.png ./outputs
  
b1 jobFile="job.json":
  rm -rf exitCode stderr stdout
  cd outputs && rm -rf exitCode stderr stdout
  cd data && rm -rf exitCode stderr stdout
  b create --download -f --output-dir './data' --wait {{jobFile}}
  mv data/*.png ./outputs