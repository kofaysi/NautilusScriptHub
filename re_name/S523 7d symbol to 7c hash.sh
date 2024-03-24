#!/bin/bash

# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <7-digit-number>"
    exit 1
fi

input_number=$1  # Input number passed as an argument

# Step 2: Sum of the Digits
sum_digits=$(echo $input_number | grep -o . | paste -sd+ | bc)

# Step 3: Reverse String and ensure it does not start with zero
reverse_string=$(echo $input_number | rev | sed 's/^0*//')

# If reverse_string is empty after removing leading zeros, assign zero to it
if [ -z "$reverse_string" ]; then
    reverse_string="0"
fi

# Step 4: Modulus 325
mod_325=$((10#$input_number % 325))

# Step 5: Pseudorandom Number
# Ensure no part is treated as an octal number by prefixing with 10#
pseudorandom_number=$((10#$input_number + 10#$reverse_string * sum_digits + mod_325))

# Step 6: Convert to hexadecimal
pseudorandom_hex=$(printf '%X' $pseudorandom_number)

# Step 7: Manipulate the string to ensure it is 7 characters long
final_hash=$(printf '%s' "$pseudorandom_hex" | rev | cut -c -7 | rev | awk '{ printf "%07s\n", $0 }' | tr ' ' '0')

# Output the final hash
echo $final_hash

