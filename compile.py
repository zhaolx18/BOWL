import tkinter as tk
from tkinter import scrolledtext
import subprocess

# Function to run the LHS1.py script and display its output
def run_lhs1():
    result = subprocess.run(["python", "LHS1.py"], capture_output=True, text=True)
    output_display.insert(tk.END, result.stdout)
    output_display.insert(tk.END, result.stderr)

# Function to run the BP-py.py script and display its output
def run_bp_py():
    result = subprocess.run(["python", "BP-py.py"], capture_output=True, text=True)
    output_display.insert(tk.END, result.stdout)
    output_display.insert(tk.END, result.stderr)


# Function to run the SOM-py.py script and display its output
def run_som_py():
    result = subprocess.run(["python", "SOM-py2.py"], capture_output=True, text=True)
    output_display.insert(tk.END, result.stdout)
    output_display.insert(tk.END, result.stderr)

# Create the main window
root = tk.Tk()
root.title("Scripts GUI")
root.geometry("600x400")

# Create buttons and associate them with their functions
btn_lhs1 = tk.Button(root, text="拉丁超立方采样", command=run_lhs1)
btn_lhs1.pack(pady=10)

btn_bp_py = tk.Button(root, text="全局非线性敏感性分析", command=run_bp_py)
btn_bp_py.pack(pady=10)

btn_som_py = tk.Button(root, text="参数取值空间优化", command=run_som_py)
btn_som_py.pack(pady=10)

# Create a scrolled text widget to display the scripts' outputs
output_display = scrolledtext.ScrolledText(root, width=70, height=10)
output_display.pack(pady=10)

root.mainloop()
