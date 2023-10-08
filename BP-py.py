# Python calling run.m (Backpropagation Multi-Dimensional Nonlinear Global Sensitivity Analysis) under Matlab program
import subprocess

def run_matlab_script(script_name):
    matlab_command = f"matlab -r \"run('{script_name}');exit;\""
    
    process = subprocess.Popen(matlab_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    
    if process.returncode != 0:
        print(f"Error executing MATLAB script. STDERR: {stderr.decode()}")
    else:
        print(f"MATLAB script executed successfully. STDOUT: {stdout.decode()}")

script_name = "E:\\Zhao\\2023-10\\BOM-2\\run8.m"   ## Replace with your actual file path
run_matlab_script(script_name)
