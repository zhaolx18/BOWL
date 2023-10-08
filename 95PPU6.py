import pandas as pd
import numpy as np
# Function to extract the second column data from a text file
def extract_observed_data(file_path):
    with open(file_path, 'r') as file:
        # Read lines, split them into parts, and extract the second part (index 1)
        # Convert the extracted part to integer and return as a list
        return [int(line.split()[1]) for line in file.readlines()]
def write_results_to_txt(d1_value, i1_value, output_txt_path):
    with open(output_txt_path, 'w') as file:
        file.write(f"P-FACTOR={d1_value:.2f}\n")
        file.write(f"R-FACTOR={i1_value:.2f}\n")
def process_and_transpose_csv(input_csv_path, output_excel_path, observed_data):
    # 1. Load the CSV file
    data = pd.read_csv(input_csv_path, header=None)
    
    # 2. Delete the first two rows and the first column
    data_cleaned = data.iloc[2:, 1:]
    
    # 3. Transpose the remaining data
    data_transposed = data_cleaned.transpose()
    
    # 4. Convert values to numeric if possible
    data_numeric = data_transposed.apply(pd.to_numeric, errors='coerce')
    
    # 5. Sort each column
    data_sorted = data_numeric.apply(lambda x: x.sort_values().values)
    
    # 6. Add a new index column
    data_sorted.insert(0, 'Index', range(1, 1 + len(data_sorted)))
    
    # 7. Add a new column with percentage
    total_count = len(data_sorted)
    data_sorted['Percentage'] = data_sorted['Index'] / total_count * 100
    
    # 8. Save the processed data to an Excel file in 'Sheet1' WITHOUT headers and indices
    with pd.ExcelWriter(output_excel_path, engine='xlsxwriter') as writer:
        data_sorted.to_excel(writer, sheet_name='Sheet1', index=False, header=False)
    # 9. Find rows close to 2.5% and 97.5% percentiles
    def find_closest_rows(df, target_percentage):
        closest_above = df[df['Percentage'] >= target_percentage].iloc[0]
        closest_below = df[df['Percentage'] <= target_percentage].iloc[-1]
        closest = (closest_above + closest_below) / 2
        return closest
        
    low_percentile_row = find_closest_rows(data_sorted, 2.5)
    high_percentile_row = find_closest_rows(data_sorted, 97.5)

    # 10. Remove 'Index' and 'Percentage' from the rows and transpose the data
    low_percentile_row = low_percentile_row.drop(['Index', 'Percentage'])
    high_percentile_row = high_percentile_row.drop(['Index', 'Percentage'])
    selected_data = pd.DataFrame([low_percentile_row, high_percentile_row]).transpose()
    # 11. Save the transposed data to the next sheet of the Excel file
    with pd.ExcelWriter(output_excel_path, engine='openpyxl', mode='a') as writer:
        # Check if 'Percentiles' sheet exists
        if 'Percentiles' not in writer.book.sheetnames:
            selected_data.to_excel(writer, sheet_name='Percentiles', index=False, header=False)
        
        # Adding the observed data to column C of 'Percentiles'
        worksheet = writer.sheets['Percentiles']
        for i, value in enumerate(observed_data):
            worksheet.cell(row=i+1, column=3, value=value)
        
        # Calculate the percentage using openpyxl
        total_rows = worksheet.max_row
        count_between = sum(1 for row in range(1, total_rows + 1) 
                            if worksheet.cell(row=row, column=3).value >= worksheet.cell(row=row, column=1).value 
                            and worksheet.cell(row=row, column=3).value <= worksheet.cell(row=row, column=2).value)
        percentage = count_between / total_rows 
        worksheet.cell(row=1, column=4, value=percentage)
        
        # Additional calculations for R-factor
        # Step 1: Calculate E column values (B - A) and write them to the worksheet
        for row in range(1, total_rows + 1):
            a_value = worksheet.cell(row=row, column=1).value  # A column value
            b_value = worksheet.cell(row=row, column=2).value  # B column value
            worksheet.cell(row=row, column=5, value=b_value - a_value)  # Write to E column

        # Step 2: Calculate the sum of E column and write it to F1
        f1_value = sum(worksheet.cell(row=row, column=5).value for row in range(1, total_rows + 1))
        worksheet.cell(row=1, column=6, value=f1_value)  # Write to F1

        # Step 3: Calculate the average of E column (F1 / total_rows) and write it to G1
        g1_value = f1_value / total_rows
        worksheet.cell(row=1, column=7, value=g1_value)  # Write to G1

        # Step 4: Calculate the standard deviation of C column and write it to H1
        c_values = [worksheet.cell(row=row, column=3).value for row in range(1, total_rows + 1)]
        h1_value = np.std(c_values, ddof=0)  # STDEV.P (Population Standard Deviation) is used
        worksheet.cell(row=1, column=8, value=h1_value)  # Write to H1

        # Step 5: Calculate I1 (G1 / H1) and write it to I1
        i1_value = g1_value / h1_value
        worksheet.cell(row=1, column=9, value=i1_value)  # Write to I1
    # Get the values from D1 and I1
    d1_value = worksheet.cell(row=1, column=4).value
    i1_value = worksheet.cell(row=1, column=9).value
    
    # Write the results to a txt file
    output_txt_path = '95PPU_result.txt'
    write_results_to_txt(d1_value, i1_value, output_txt_path)
        

observed_file_path = 'E:\\Zhao\\2023-10\\BOM-2\\observed.txt'  # Replace with your actual file path
observed_data = extract_observed_data(observed_file_path)
input_csv_path = 'E:\\Zhao\\2023-10\\BOM-2\\MergedCSV_DataOnly.csv'
output_excel_path = 'E:\\Zhao\\2023-10\\BOM-2\\95PPU.xlsx'
process_and_transpose_csv(input_csv_path, output_excel_path, observed_data)
