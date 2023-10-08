import pandas as pd

def process_and_transpose_csv(input_csv_path, output_excel_path):
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

    # 10. Transpose the data
    selected_data = pd.DataFrame([low_percentile_row, high_percentile_row]).transpose()

    # 11. Save the transposed data to the next sheet of the Excel file
    with pd.ExcelWriter(output_excel_path, engine='openpyxl', mode='a') as writer:
        selected_data.to_excel(writer, sheet_name='Percentiles', index=False, header=False)

# Example usage
input_csv_path = 'E:\\Zhao\\2023-10\\BOM-2\\MergedCSV_DataOnly2.csv'
output_excel_path = 'E:\\Zhao\\2023-10\\BOM-2\\95PPU.xlsx'
process_and_transpose_csv(input_csv_path, output_excel_path)
