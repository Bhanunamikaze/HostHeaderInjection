# This Script is used to 

import glob
import os
import subprocess
from concurrent.futures import ThreadPoolExecutor, as_completed

SEMGRPE_EXECUTABLE = "~/.local/bin/semgrep" 

def run_semgrep(yaml_file, directory_path):
    last_directory = os.path.basename(os.path.normpath(directory_path))
    base_path, _ = os.path.splitext(yaml_file)
    file_name = os.path.basename(base_path)

    semgrep_command = (
        f"{SEMGRPE_EXECUTABLE} --config={yaml_file} {directory_path} "
        f"--output='strk/Download   s/rules/Output/{file_name}_{last_directory}.json' --json"
    )
    subprocess.run(semgrep_command, shell=True)
    return f"Completed: {file_name} on {last_directory}"

def process_directory(directory_path):
    config_file_path = "strk/Downloads/rules/"
    yaml_files = glob.glob(os.path.join(config_file_path, "**", "*.yaml"), recursive=True)

    if not yaml_files:
        return f"No YAML files found in {config_file_path} for {directory_path}."

    with ThreadPoolExecutor() as executor:
        futures = {executor.submit(run_semgrep, yaml_file, directory_path): yaml_file for yaml_file in yaml_files}

        for future in as_completed(futures):
            result = future.result()
            print(result)

def main():
    directory_paths = [
        "strk/app/Console/",
        "strk/app/Controller/",
        "strk/app/Model/",
        "strk/app/Vendor/",
        "strk/app/View/",
        "strk/app/webroot/"
    ]

    with ThreadPoolExecutor() as executor:
        futures = {executor.submit(process_directory, directory_path): directory_path for directory_path in directory_paths}

        for future in as_completed(futures):
            result = future.result()
            print(result)

if __name__ == "__main__":
    main()
