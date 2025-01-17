{
    "machine": {
        "gpu": {{ if eq .Device "cpu" }}0{{ else }}{{(or .gpu 1 )}}{{ end }},
        "ram": {{ mul (regex "\\d+" (or .ram "16gb")) 1000 }},
        "cpu": {{ mul (or .cpu "18") 1000 }}
    },
    "job": {
        "APIVersion": "V1beta1",
        "Spec": {
            "Deal": {
                "Concurrency": 1
            },
           "Docker": {
                "Entrypoint": [
                    "bash", "-c",
                    "python3 /app/inference.py"
                ],
                "Image": "ghcr.io/darts2024/isdxl:{{ or .dockerTag "v1.7.0"}}",
                "EnvironmentVariables": [
                    {{if .Prompt}}"{{ subt "PROMPT=%s" .Prompt }}"{{else}}"PROMPT=cute rabbit in a spacesuit"{{end}},
                    "{{ subt "RANDOM_SEED=%s" (or .Seed "1")  }}",
                    "{{ subt "NUM_IMAGES=%s" (or .N "1")  }}",
                    "{{ subt "DEVICE=%s" (or .Device "xpu")  }}",
                    "{{ subt "IMAGE_FORMAT=%s" (or .Format "webp")  }}",
                    "{{ subt "CPU_OFFLOAD=%s" (or .CpuOffload "0")  }}",
                    "OUTPUT_DIR=/outputs/",
                    "HF_HUB_OFFLINE=1"
                ]
            },
            "Engine": "Docker",
            "Language": {
                "JobContext": {}
            },
            "Network": {
                "Type": "None"
            },
            "PublisherSpec": {
                "Type": "local"
            },
            "Resources": {
                "GPU": "{{ if (eq .Device "cpu") }}0{{ else }}{{(or .gpu 1 )}}{{ end }}",
                "Memory": "{{(or .ram "16gb")}}",
                "CPU": "{{ or .cpu "18" }}"
           },
            "Timeout": 1800,
            "Verifier": "Noop",
            "Wasm": {
                "EntryModule": {}
            },
            "outputs": [
                {
                    "Name": "outputs",
                    "path" :"/outputs"
                }
            ]
        }
    }
}
