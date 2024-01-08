#!/bin/bash

# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <7-digit-number>"
    exit 1
fi

input_number=$1  # Input number passed as an argument

# Step 2: Sum of the Digits
sum_digits=$(echo $input_number | grep -o . | paste -sd+ | bc)

# Step 3: Reverse String
reverse_string=$(echo $input_number | rev | sed 's/^0*//')

# Step 4: Modulus 325
mod_325=$(($input_number % 325))

# Step 5: Pseudorandom Number
pseudorandom_number=$(($input_number + $reverse_string * $sum_digits + $mod_325))

# Step 8: Final Hash Calculation
final_hash=$(printf '%07X\n' $(($input_number + $reverse_string * $sum_digits + $mod_325)))

echo $final_hash

