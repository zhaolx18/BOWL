# BP-SA+SOM (BOM)
A systematic program for the calibration and uncertainty analysis of hydrological models, using the Soil and Water Assessment Tool (SWAT) as an example
Code Language
Python: 3.9.12
MATLAB: 7
Required Python Packages
tkinter
subprocess
threading
pandas
numpy
multiprocessing
multiprocessing.pool
shutil
pyDOE2
csv
os
datetime
math
Usage
1. Latin Hypercube Sampling (LHS) - compile2.py (BOM User Interface / Console)
Configuration File: Parameters.txt (see inside the file for writing requirements)
Runoff Measured Data: observed.txt
Study Area Soil Type: soil.csv
Original Model Parameter Files: Store in the Rawmodel folder. The content from the SWAT TxInOut folder can be copied here.
Output: After running, BP.xls will contain the sampling results. Handle the file format as shown in the test case to prepare for subsequent operations.
2. Model Uncertainty Analysis - 95PPU
Sampling Process File: MergedCSV_DataOnly. The model uncertainty (95PPU) can be calculated based on this.
Output: The results are stored in 95PPU_result.txt.
3. BP Multi-Dimensional Nonlinear Global Sensitivity Analysis
Configuration File: config-BP. It reads the corresponding rows and columns from BP.xls to perform calculations.
4. SOM for Parameter Range Optimization
Configuration File: config-SOM. It reads the corresponding rows and columns from BP.xls to perform calculations.
