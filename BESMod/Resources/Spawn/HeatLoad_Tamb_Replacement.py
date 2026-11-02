def replace_temperature_value(city_name, new_temp):
    try:
        # Fixed input filenames
        mos_input = "Potsdam_HeatLoad.mos"
        epw_input = "Potsdam_HeatLoad.epw"

        temp_str = str(new_temp).replace("-", "m").replace(".", "_")
        
        # Generate output filenames with new city name
        mos_output = f"{city_name}_HeatLoad_{temp_str}.mos"
        epw_output = f"{city_name}_HeatLoad_{temp_str}.epw"
        
        # Fixed old temperature
        old_temp = "-12.0"
        
        # Process MOS file
        with open(mos_input, 'r') as file:
            content = file.read()
        updated_content = content.replace(old_temp, new_temp)
        with open(mos_output, 'w') as file:
            file.write(updated_content)
            
        # Process EPW file
        with open(epw_input, 'r') as file:
            content = file.read()
        updated_content = content.replace(old_temp, new_temp)
        with open(epw_output, 'w') as file:
            file.write(updated_content)
            
        return True
        
    except Exception as e:
        return str(e)

def main():
    print("Temperature Replacement")
    print("-" * 30)
    
    # Get city name
    city_name = input("Enter new city name (e.g., Berlin): ")
    
    # Get new temperature value
    new_temp = input("Enter new outdoor air temperature value in °C (e.g., -7.0): ")
    
    print("\nProcessing...")
    
    # Perform the replacement
    result = replace_temperature_value(city_name, new_temp)
    temp_str = str(new_temp).replace("-", "m").replace(".", "_")

    print("\nTemperature Replacement")
    
    if result == True:
        print(f"\nSuccess! -12.0 has been replaced with {new_temp} in both files")
        print(f"MOS output saved as: {city_name}_HeatLoad_{temp_str}.mos")
        print(f"EPW output saved as: {city_name}_HeatLoad_{temp_str}.epw")
    else:
        print(f"\nError occurred: {result}")
    
    print("\nPress Enter to exit...")
    input()

if __name__ == "__main__":
    main()