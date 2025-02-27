#!/usr/bin/env uv run -s
# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "argparse",
# ]
#

import argparse
import json
import shutil
import subprocess
import sys
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Literal, Optional, TypedDict, Union


class ResourcesDict(TypedDict):
    CPU: str
    Memory: str
    GPU: str


class NetworkDict(TypedDict):
    Type: str


class OutputDict(TypedDict):
    Name: str
    Path: str


class DockerParams(TypedDict):
    Image: str
    Entrypoint: List[str]
    EnvironmentVariables: Dict[str, Any]


class EngineSpec(TypedDict):
    Type: str
    Params: DockerParams


class PublisherSpec(TypedDict):
    Type: Literal["Local"]


class TaskDict(TypedDict):
    Name: str
    Engine: EngineSpec
    PublisherSpec: PublisherSpec
    Resources: ResourcesDict
    Network: NetworkDict
    Timeout: int
    Outputs: List[OutputDict]


class NewJobDict(TypedDict):
    Type: Literal["batch"]
    Count: int
    Tasks: List[TaskDict]


class OldDockerSpec(TypedDict):
    Image: str
    Entrypoint: List[str]
    EnvironmentVariables: List[str]


class OldEngineSpec(TypedDict):
    Type: str
    Params: Optional[Dict[str, Any]]


class OldSpec(TypedDict):
    Engine: str
    EngineSpec: OldEngineSpec
    PublisherSpec: PublisherSpec
    Docker: OldDockerSpec
    Resources: ResourcesDict
    Network: NetworkDict
    Timeout: int
    Outputs: List[OutputDict]


class OldMetadata(TypedDict):
    CreatedAt: str
    Requester: Dict[str, Any]


class OldJobDict(TypedDict):
    APIVersion: str
    Metadata: OldMetadata
    Spec: OldSpec


def convert_job(old_job: OldJobDict) -> NewJobDict:
    """Convert old job format to new job format."""
    spec = old_job.get(
        "Spec",
        OldSpec(
            Engine="",
            EngineSpec=OldEngineSpec(Type="", Params=None),
            PublisherSpec=PublisherSpec(Type="Local"),
            Docker=OldDockerSpec(Image="", Entrypoint=[], EnvironmentVariables=[]),
            Resources=ResourcesDict(CPU="", Memory="", GPU=""),
            Network=NetworkDict(Type="None"),
            Timeout=1800,
            Outputs=[],
        ),
    )
    docker_spec = spec.get(
        "Docker", OldDockerSpec(Image="", Entrypoint=[], EnvironmentVariables=[])
    )

    # Create the new task structure
    task: TaskDict = {
        "Name": "inference job",
        "Engine": {
            "Type": spec.get("Engine", "Docker"),
            "Params": {
                "Image": docker_spec.get("Image", ""),
                "Entrypoint": docker_spec.get("Entrypoint", []),
                "EnvironmentVariables": docker_spec.get("EnvironmentVariables", {}),
            },
        },
        "PublisherSpec": spec.get("PublisherSpec", {"Type": "Local"}),
        "Resources": spec.get("Resources", ResourcesDict(CPU="", Memory="", GPU="")),
        "Network": spec.get("Network", {"Type": "None"}),
        "Timeout": spec.get("Timeout", 1800),
        "Outputs": spec.get("Outputs", []),
    }

    # Create the new job structure
    new_job: NewJobDict = {"Type": "batch", "Count": 1, "Tasks": [task]}

    return new_job


def get_output_filename(original_filename: str) -> str:
    """Generate a new filename with timestamp if the original file exists."""
    path: Path = Path(original_filename)
    if not path.exists():
        return original_filename

    timestamp: str = datetime.now().strftime("%Y%m%d%H%M%S")
    return f"{path.stem}-{timestamp}{path.suffix}"


def validate_job(filename: str) -> tuple[bool, str]:
    """Validate the job spec using bacalhau CLI if available."""
    bacalhau_path: Optional[str] = shutil.which("bacalhau")
    if not bacalhau_path:
        return False, "bacalhau binary not found in PATH"

    try:
        result: subprocess.CompletedProcess[str] = subprocess.run(
            [bacalhau_path, "job", "validate", filename],
            capture_output=True,
            text=True,
            check=True,
        )
        return True, "Job validation successful"
    except subprocess.CalledProcessError as e:
        return False, f"Job validation failed: {e.stderr}"
    except Exception as e:
        return False, f"Error during validation: {str(e)}"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Convert job specification formats",
        epilog="If bacalhau is available in PATH, the output file will be validated. "
        "If the output file already exists, a new file with timestamp will be created.",
    )
    parser.add_argument("input_file", help="Input job specification file")
    parser.add_argument("output_file", help="Output job specification file")
    parser.add_argument(
        "-q",
        "--quiet",
        action="store_true",
        help="Suppress printing the converted job specification",
    )

    args = parser.parse_args()

    try:
        with open(args.input_file, "r") as f:
            old_job: OldJobDict = json.load(f)
    except Exception as e:
        print(f"Error reading input file: {e}", file=sys.stderr)
        sys.exit(1)

    try:
        new_job = convert_job(old_job)
    except Exception as e:
        print(f"Error converting job: {e}", file=sys.stderr)
        sys.exit(1)

    # Get appropriate output filename
    output_file = get_output_filename(args.output_file)

    try:
        with open(output_file, "w") as f:
            json.dump(new_job, f, indent=4)
        print(f"Job specification written to: {output_file}")
    except Exception as e:
        print(f"Error writing output file: {e}", file=sys.stderr)
        sys.exit(1)

    # Validate if bacalhau is available
    success, message = validate_job(output_file)
    if not success:
        print(f"Warning: {message}", file=sys.stderr)
    else:
        print(message)

    # Print the job spec unless quiet mode is enabled
    if not args.quiet:
        print("\nConverted Job Specification:")
        print(json.dumps(new_job, indent=4))


if __name__ == "__main__":
    main()