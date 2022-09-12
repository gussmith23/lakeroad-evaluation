from pathlib import Path


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
