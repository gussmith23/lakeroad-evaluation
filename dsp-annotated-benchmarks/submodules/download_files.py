import yaml
import subprocess

def main():
    with open("files.yml") as f:
        files = yaml.safe_load(f)
    
    for file in files:
        subprocess.run(['wget', '-O', file['dest_filename'], file['url']], check=True)

if __name__=="__main__":
    main()