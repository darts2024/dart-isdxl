{
    "machine": {
        "gpu": {{ if eq .Device "cpu" }}0{{ else }}1{{ end }},
        "ram": {{ mul (regex "\\d+" (or .memory "16gb")) 1000 }},
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
                    "python3 /app/inference.py 2>/dev/null"
                ],
                "Image": "ghcr.io/darts2024/isdxl:{{ or .dockerTag "v1.0.2"}}",
                "EnvironmentVariables": [
                    {{if .Prompt}}"{{ subt "PROMPT=%s" .Prompt }}"{{else}}"PROMPT=cute rabbit in a spacesuit"{{end}},
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
                "GPU": "{{ if (eq .Device "cpu") }}0{{ else }}1{{ end }}",
                "Memory": "{{(or .memory "16gb")}}",
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
