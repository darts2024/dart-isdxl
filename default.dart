{
    "machine": {
        "gpu": 1,
        "ram": 100,
        "cpu": 1000
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
                    "python3 /app/inference.py 2>/dev/null"
                ],
                "Image": "laciferin/isdxl:v0.0.7",
                "EnvironmentVariables": [
                    {{if .Prompt}}"{{ subt "PROMPT=%s" .Prompt }}"{{else}}"PROMPT=cat sitting on a park bench"{{end}},
                    "{{ subt "RANDOM_SEED=%s" (or .Seed "42")  }}",
                    "{{ subt "DEVICE=%s" (or .Device "xpu")  }}",
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
                "CPU": "{{ if eq .Device "cpu" }}5{{ else }}3{{ end }}",
                "Memory": "{{(or .Memory "8gb")}}",
                "GPU": "{{ if eq .Device "cpu" }}0{{ else }}1{{ end }}"
            },
            "Timeout": 1800,
            "Verifier": "Noop",
            "Wasm": {
                "EntryModule": {}
            },
            "outputs": [
                {
                    "Name": "outputs",
                    "path": "/outputs"
                }
            ]
        }
    }
}
