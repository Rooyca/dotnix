import json

def transform_records(input_file, output_file):
    """
    Reads JSON data from a file, transforms it to the desired format,
    and saves the transformed data to a new file.
    """
    try:
        # Read the original data from the input file
        with open(input_file, 'r') as file:
            data = json.load(file)
        
        # Transform the data
        transformed = []
        for record in data.get("records", []):
            transformed.append({
                "id": record["id"],
                "date": record["datetime"],
                "description": record.get("description"),
                "category": record["category_name"],
                "amount": record["value"]
            })
        
        # Write the transformed data to the output file
        with open(output_file, 'w') as file:
            json.dump(transformed, file, indent=4)
        
        print(f"Transformed data has been saved to {output_file}")
    
    except Exception as e:
        print(f"An error occurred: {e}")

# Input and output file paths
input_file = 'input.json'  # Replace with your input file name
output_file = 'output.json'  # Replace with your desired output file name

# Run the transformation
transform_records(input_file, output_file)
