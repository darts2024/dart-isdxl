{
    "machine": {
        "gpu": {{ if eq .Device "cpu" }}0{{ else }}1{{ end }},
        "ram": 8000,
        "cpu": {{ if eq .Device "cpu" }}6000{{ else }}3000{{ end }}
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
                "Image": "ghcr.io/darts2024/isdxl:{{ or .dockerTag "v0.3.3"}}",
                "EnvironmentVariables": [
                    {{if .Prompt}}"{{ subt "PROMPT=%s" .Prompt }}"{{else}}"PROMPT=cat sitting on a park bench"{{end}},
                    "{{ subt "RANDOM_SEED=%s" (or .Seed "1")  }}",
                    "{{ subt "DEVICE=%s" (or .Device "cpu")  }}",
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
                "CPU": "{{ if (eq .Device "cpu") }}{{(or .cpu "6")}}{{ else }}3{{ end }}",
                "Memory": "{{(or .memory "8gb")}}",
                "GPU": "{{ if (eq .Device "cpu") }}0{{ else }}1{{ end }}"
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
