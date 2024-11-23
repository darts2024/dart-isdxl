{
    "machine": {
        "gpu": 1,
        "ram": 3000,
        "cpu": 3000
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
                "Image": "ghcr.io/darts2024/isdxl:v0.3.0",
                "EnvironmentVariables": [
                    {{if .Prompt}}"{{ subt "PROMPT=%s" .Prompt }}"{{else}}"PROMPT=cat sitting on a park bench"{{end}},
                    "{{ subt "RANDOM_SEED=%s" (or .Seed "42")  }}",
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
                "CPU": "3",
                "Memory": "3gb",
                "GPU": "1"
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
