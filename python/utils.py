from pathlib import Path

def lakeroad_evaluation_dir() -> Path:
    """Return the path to the Lakeroad evaluation directory."""
    return Path(__file__).parent.parent.resolve()
