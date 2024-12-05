{
    "machine": {
        "gpu": {{ if eq .Device "cpu" }}0{{ else }}1{{ end }},
        "ram": {{ mul (regex "\d+" (or .memory "22gb")) 1000}},
        "cpu": {{ if eq .Device "cpu" }}{{ mul (or .cpu "27") 1000 }}{{ else }}26000{{ end }}
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
                "CPU": "{{ if (eq .Device "cpu") }}{{(or .cpu "27")}}{{ else }}26{{ end }}",
                "Memory": "{{(or .memory "22gb")}}",
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
                    "path" :"/outputs"
                }
            ]
        }
    }
}
