from pathlib import Path
import os
from typing import Dict
import yaml


def lakeroad_evaluation_dir() -> Path:
    """Return the path to the Lakeroad evaluation directory."""
    return Path(__file__).parent.parent.resolve()


def make_module_name(
    architecture: str, instruction_name: str, bitwidth: int, arity: int
) -> str:
    architecture_with_underscores = architecture.replace("-", "_")
    return (
        f"lakeroad_{architecture_with_underscores}_{instruction_name}{bitwidth}_{arity}"
    )


def output_dir() -> Path:
    """Get directory where output should go.

    Output directory is set (in order of precedence)
    1. from the OUTPUT_DIR environment variable, if set;
    2. from a default value.
    """
    DEFAULT_VALUE = lakeroad_evaluation_dir() / "out"

    out = DEFAULT_VALUE

    if "OUTPUT_DIR" in os.environ:
        out = Path(os.environ["OUTPUT_DIR"])

    return out


def _manifest_path() -> Path:
    """Get path to the manifest file.

    You should not need to call this function directly. Instead, use
    get_manifest().

    Manifest file is set (in order of precedence):

    1. from the LRE_MANIFEST_PATH environment variable, if set;
    2. from a default value.
    """
    return (
        Path(os.environ["LRE_MANIFEST_PATH"])
        if "LRE_MANIFEST_PATH" in os.environ
        else lakeroad_evaluation_dir() / "manifest.yml"
    )


def get_manifest() -> Dict:
    manifest = yaml.safe_load(_manifest_path().read_text())

    # Override values from environment variables. This section of the code
    # allows us to override any manifest values using environment variables. Add
    # lines like `manifest["key"] = os.environ["KEY"]` to add an override.
    if "LRE_ITERATIONS" in os.environ:
        manifest["iterations"] = int(os.environ["LRE_ITERATIONS"])

    return manifest
