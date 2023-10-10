# BP-SA+SOM (BOM)

A systematic program for the calibration and uncertainty analysis of hydrological models, using the [Soil and Water Assessment Tool (SWAT)](https://swat.tamu.edu/) as an example.

## Prerequisites

### Code Language

- **Python:** 3.9.X
- **MATLAB:** 7

### Required Python Packages

- tkinter
- threading
- pandas
- numpy
- pyDOE2
- csv
- openopyxl

## Usage

### [`compile2.py` (BOM User Interface)](compile2.py)

#### Test Case

The [`test_case`](test_case) folder includes example input and output files for the model.

> **Attention:** You need to specify the actual file locations in the following Python scripts (See Comments in scripts):
> - [`95PPU6.py`](95PPU6.py)
> - [`BP-py.py`](BP-py.py)
> - [`SOM.py`](SOM.py)

### Usage Steps 

#### 1. Latin Hypercube Sampling: `LHS1.py`

- **Configuration File:** `Parameters.txt`
- **Runoff Measured Data:** `observed.txt`
- **Study Area Soil Type:** `soil.csv`
- **Original Model Parameter Files:** `RawModel` (The content from the SWAT `TxInOut` folder could be copied here. Examples could be seen in the `Rawmodel` within the `input` folder in the `test_case` directory.)
- **Output:** `BP.xls` will contain the sampling results and object functions. Handle the file format as shown in the `BP.xls` within the `input` folder to prepare for subsequent operations.

#### 2. Model Uncertainty Analysis - 95PPU

- **Sampling Process File:** `MergedCSV_DataOnly` (Sample at least 500 times for uncertainty analysis to calculate the model uncertainty (95PPU).)
- **Output:** The results are stored in `95PPU_result.txt`.

#### 3. BP Multi-Dimensional Nonlinear Global Sensitivity Analysis

- **Configuration File:** `config-BP` (It reads the corresponding rows and columns from `BP.xls` to perform calculations.)
- **Output:** Results are presented graphically. The larger the value, the higher the sensitivity. Values from different simulation runs could not be compared.

#### 4. SOM for Parameter Range Optimization

- **Configuration File:** `config-SOM` (It reads the corresponding rows and columns from `BP.xls` to perform calculations.)
- **Output:** Select the best category from the output images and output it to the command line.
  - `SOM-results.xls`: Cluster Result Output File
  - `SOM-range.xls`: Parameter range optimization results

## License

This project is licensed under the [GPLv3] - see the [LICENSE](LICENSE) for details.

## Contact

Lixin Zhao - [zlx22@mails.jlu.edu.cn](mailto:zlx22@mails.jlu.edu.cn)

## Acknowledgments

- **[[Hongyan Li](https://teachers.jlu.edu.cn/LHY29/zh_CN/index.htm)/[Changhai Li](https://github.com/IchinoseHimeki)]**: For their invaluable insights and expertise in developing the core algorithm that significantly enhanced the performance of our model. Their innovative approaches to problem-solving and tireless dedication to research excellence greatly influenced the success of our project.
