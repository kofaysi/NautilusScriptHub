#!/usr/bin/env python3

import pyperclip

# Dictionary for replacements
replacement_dict = {
    '=a': 'á',
    '=e': 'é',
    '=i': 'í',
    '=o': 'ó',
    '+r': 'ř',
    '+t': 'ť',
    '+e': 'ě',
    '+n': 'ň',
    '+s': 'š',
    '+c': 'č',
    '+z': 'ž',
    '+d': 'ď',
    '+l': 'ľ',
    '+u': 'ü',  # for umlaut 'u'
    '+o': 'ö',  # for umlaut 'o'
    '+a': 'ä',  # for umlaut 'a'
    '\" : \"': ':',  # Replace double apostrophe with a colon
    ';': 'ů'
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

