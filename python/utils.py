from pathlib import Path
import os
from typing import Dict, Optional
import yaml


LRE_OUTPUT_DIR_ENV_VAR = "LRE_OUTPUT_DIR"
LRE_MANIFEST_PATH_ENV_VAR = "LRE_MANIFEST_PATH"
LRE_ITERATIONS_ENV_VAR = "LRE_ITERATIONS"


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
    1. from the LRE_OUTPUT_DIR environment variable, if set;
    2. from the manifest.
    """

    # Output directory is set by the LRE_OUTPUT_DIR environment variable, if
    # it's set. Otherwise, get it from the manifest.
    out = Path(
        os.environ[LRE_OUTPUT_DIR_ENV_VAR]
        if LRE_OUTPUT_DIR_ENV_VAR in os.environ
        else get_manifest()["output_dir"]
    )

    # If the path is relative, we assume it's relative to the Lakeroad
    # evaluation directory.
    if not out.is_absolute():
        out = lakeroad_evaluation_dir() / out

    out = out.resolve()

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
        Path(os.environ[LRE_MANIFEST_PATH_ENV_VAR])
        if LRE_MANIFEST_PATH_ENV_VAR in os.environ
        else lakeroad_evaluation_dir() / "manifest.yml"
    )


def get_manifest() -> Dict:
    manifest = yaml.safe_load(_manifest_path().read_text())

    # Override values from environment variables. This section of the code
    # allows us to override any manifest values using environment variables. Add
    # lines like `manifest["key"] = os.environ["KEY"]` to add an override.
    if LRE_ITERATIONS_ENV_VAR in os.environ:
        manifest["iterations"] = int(os.environ[LRE_ITERATIONS_ENV_VAR])

    return manifest
