import yaml
import subprocess
from pathlib import Path


def main():
    with open("manifest.yml") as f:
        files = yaml.safe_load(f)

    for file in files:
        Path(file['dest_filename']).parent.mkdir(exist_ok=True, parents=True)
        result = subprocess.run(
            [
                "yosys",
                "-p",
                f"""
read_verilog {file['filename']}
hierarchy -check -top {file['top_module']}
flatten
write_verilog {file['dest_filename']}""",
            ],
            capture_output=True
        )
        
        if result.returncode:
            raise Exception(result.stderr.decode())


if __name__ == "__main__":
    main()
