from pathlib import Path
import doit
import os


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
    2. from the output_dir DoIt command line arg, if set (e.g. `doit
       output_dir=$PWD/out`),
    3. from a default value.
    """
    DEFAULT_VALUE = lakeroad_evaluation_dir() / "out"
    
    out = DEFAULT_VALUE

    out =  Path(doit.get_var("output_dir", out))

    if "OUTPUT_DIR" in os.environ:
        out = Path(os.environ["OUTPUT_DIR"])
    
    return out
