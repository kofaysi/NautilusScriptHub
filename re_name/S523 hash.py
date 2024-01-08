import sys

def calculate_hash(input_number):
    # Ensure the input is a string
    input_str = str(input_number)
    
    # Step 2: Sum of the Digits
    sum_digits = sum(int(digit) for digit in input_str)
    
    # Step 3: Reverse String
    reverse_string = input_str[::-1]
    
    # Step 4: Modulus 325
    mod_325 = int(input_str) % 325
    
    # Step 5: Pseudorandom Number
    pseudorandom_number = int(input_str) + int(reverse_string) * sum_digits + mod_325
    
    # Step 8: Final Hash Calculation
    final_hash = format(pseudorandom_number, 'X')[-7:]  # Get the last 7 characters
    return final_hash.zfill(7)  # Pad with zeros if necessary

def main():
    if len(sys.argv) != 2:
        print("Usage: python hash_calculator.py <7-digit-number>")
        return

    input_number = sys.argv[1]
    
    # Validate that the input is a 7-digit number
    if not input_number.isdigit() or len(input_number) != 7:
        print("The input must be a 7-digit number.")
        return
    
    # Calculate the hash
    hash_value = calculate_hash(input_number)
    print(hash_value)

if __name__ == "__main__":
    main()

