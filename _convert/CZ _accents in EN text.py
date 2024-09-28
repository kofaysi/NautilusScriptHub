#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Script Name: Text Replacement Script
# Version: 1.1
# Author: kofaysi@guthub.com
# Date: 2024-09-28
#
# Description:
# This script replaces specific substrings in text with their corresponding 
# accented or umlauted characters, as defined in the replacement dictionary.
# Additionally, it replaces certain special characters (!@#$%^&*()) with numbers (1234567890).
# The script reads text from the clipboard, performs the replacements, and 
# then copies the modified text back to the clipboard.
#
# Version History:
# 1.0 - Initial version: Implemented basic replacements for accented characters.
# 1.1 - Added support for circumflex-accented characters and fixed dictionary keys.
# 1.2 - Added replacements for special characters !@#$%^&*() to 1234567890.
#

import pyperclip

# Dictionary for replacements including capital letters and special characters
replacement_dict = {
    # Acute accented letters
    '=a': 'á', '=A': 'Á',  # Replace 'a' with acute 'á' and 'A' with acute 'Á'
    '=e': 'é', '=E': 'É',  # Replace 'e' with acute 'é' and 'E' with acute 'É'
    '=i': 'í', '=I': 'Í',  # Replace 'i' with acute 'í' and 'I' with acute 'Í'
    '=o': 'ó', '=O': 'Ó',  # Replace 'o' with acute 'ó' and 'O' with acute 'Ó'
    '=u': 'ú', '=U': 'Ú',  # Replace 'u' with acute 'ú' and 'U' with acute 'Ú'
    '=y': 'ý', '=Y': 'Ý',  # Replace 'y' with acute 'ý' and 'Y' with acute 'Ý'
    '=l': 'ĺ', '=L': 'Ĺ',  # Replace 'l' with acute 'ĺ' and 'L' with acute 'Ĺ'

    # Caron accented letters (háček)
    '+r': 'ř', '+R': 'Ř',  # Replace 'r' with caron 'ř' and 'R' with caron 'Ř'
    '+t': 'ť', '+T': 'Ť',  # Replace 't' with caron 'ť' and 'T' with caron 'Ť'
    '+e': 'ě', '+E': 'Ě',  # Replace 'e' with caron 'ě' and 'E' with caron 'Ě'
    '+n': 'ň', '+N': 'Ň',  # Replace 'n' with caron 'ň' and 'N' with caron 'Ň'
    '+s': 'š', '+S': 'Š',  # Replace 's' with caron 'š' and 'S' with caron 'Š'
    '+c': 'č', '+C': 'Č',  # Replace 'c' with caron 'č' and 'C' with caron 'Č'
    '+z': 'ž', '+Z': 'Ž',  # Replace 'z' with caron 'ž' and 'Z' with caron 'Ž'
    '+d': 'ď', '+D': 'Ď',  # Replace 'd' with caron 'ď' and 'D' with caron 'Ď'
    '+l': 'ľ', '+L': 'Ľ',  # Replace 'l' with caron 'ľ' and 'L' with caron 'Ľ'

    # Circumflex accented letters (caron over vowels)
    '+u': 'ǔ', '+U': 'Ǔ',  # Replace 'u' with circumflex 'ǔ' and 'U' with circumflex 'Ǔ'
    '+o': 'ǒ', '+O': 'Ǒ',  # Replace 'o' with circumflex 'ǒ' and 'O' with circumflex 'Ǒ'
    '+a': 'ǎ', '+A': 'Ǎ',  # Replace 'a' with circumflex 'ǎ' and 'A' with circumflex 'Ǎ'

    # Umlauted letters (diaeresis)
    '\\a': 'ä',  '\\A': 'Ä',  # Replace 'a' with umlaut 'ä' and 'A' with umlaut 'Ä'
    '\\o': 'ö',  '\\O': 'Ö',  # Replace 'o' with umlaut 'ö' and 'O' with umlaut 'Ö'
    '\\u': 'ü',  '\\U': 'Ü',  # Replace 'u' with umlaut 'ü' and 'U' with umlaut 'Ü'

    # Special replacements
    ';': 'ů',  # Replace semicolon with 'ů'
    '\:': 'Ů',  # Replace colon with 'Ů'
    # '\:': ':',  # alternative: Replace double apostrophe with a colon

    # Special character to number replacements
    '!': '1',  # Replace '!' with '1'
    '@': '2',  # Replace '@' with '2'
    '#': '3',  # Replace '#' with '3'
    '$': '4',  # Replace '$' with '4'
    '%': '5',  # Replace '%' with '5'
    '^': '6',  # Replace '^' with '6'
    '&': '7',  # Replace '&' with '7'
    '*': '8',  # Replace '*' with '8'
    '(': '9',  # Replace '(' with '9'
    ')': '0',  # Replace ')' with '0'
}

def replace_text(text, replacements):
    """ Replace substrings in text based on the replacement dictionary. """
    for old, new in replacements.items():
        text = text.replace(old, new)
    return text

# Read text from clipboard
clipboard_text = pyperclip.paste()

# Replace text based on the dictionary
modified_text = replace_text(clipboard_text, replacement_dict)

# Write modified text back to clipboard
pyperclip.copy(modified_text)

print("Text has been modified and updated in the clipboard.")
