# NautilusScriptHub

## About
NautilusScriptHub is a collection of useful scripts for Nautilus, the file manager for the GNOME desktop environment. These scripts enhance the functionality of Nautilus by providing additional commands and features.

## Prerequisites
- GNOME Nautilus file manager
- Appropriate permissions to execute scripts

## Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/NautilusScriptHub.git

2. Copy the scripts to your Nautilus scripts directory:

    ```bash
    cp NautilusScriptHub/* ~/.local/share/nautilus/scripts/

3. Give execute permissions to the scripts:
    ```bash
    chmod +x ~/.local/share/nautilus/scripts/*

## Usage

- Right-click on a file or directory in Nautilus.
- Navigate to 'Scripts'.
- Select the script you wish to run.

## Script Description

Below is a current list of scripts grouped by folder. Each entry includes a short description and example usage.

#### .

#### `_repopulate-scripts-to-PATH.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_repopulate-scripts-to-PATH.sh`

#### `commit and _push.sh`

- Description: Automates the process of committing and pushing changes in the current branch.
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./commit and _push.sh`

#### `script_utils.sh`

- Description: This script collects the common script functions. The file is imported in other Nautilus bash scripts.
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./script_utils.sh`

#### _attributes

#### `_attributes/_path.sh`

- Description: This script takes a file or directory path as an argument, resolves it to its absolute path, and copies the result to the clipboard.
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_attributes/_path.sh`

#### `_attributes/_touch.sh`

- Description: This script updates the last modified timestamp of selected files in Nautilus to the current time.
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_attributes/_touch.sh`

#### `_attributes/set _atime by alpha.sh`

- Description: !/usr/bin/env bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_attributes/set _atime by alpha.sh`
     - Example: `./_attributes/set _atime by alpha.sh $0 [-s seconds_step] FILE... | DIRECTORY`

#### _convert

#### `_convert/PDF extract _symboly.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/PDF extract _symboly.sh`

#### `_convert/PDF to _JPEGs.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/PDF to _JPEGs.sh`

#### `_convert/PDF to _PNGs.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/PDF to _PNGs.sh`

#### `_convert/PDFs to _A4 format centered.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/PDFs to _A4 format centered.sh`

#### `_convert/calculate and apply _album gain.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/calculate and apply _album gain.sh`

#### `_convert/compare _pdfs.sh`

- Description: Bash script to compare two PDFs page by page and highlight differences using subtraction in ImageMagick
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/compare _pdfs.sh`

#### `_convert/convert to _edged.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/convert to _edged.sh`

#### `_convert/e_xtract MP3 and normalise.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/e_xtract MP3 and normalise.sh`

#### `_convert/image to _PDF A4.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/image to _PDF A4.sh`

#### `_convert/image to _PDF.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/image to _PDF.sh`

#### `_convert/images to _PNG.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/images to _PNG.sh`

#### `_convert/invert.sh`

- Description: /bin/sh
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/invert.sh`

#### `_convert/media to AndroidTV mp4.sh`

- Description: Nautilus “Scripts” approach (right-click → Scripts → Convert for AndroidTV)
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/media to AndroidTV mp4.sh`

#### `_convert/to _FLAC 16k.sh`

- Description: !/usr/bin/env bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/to _FLAC 16k.sh`

#### `_convert/to _voice (MP3).sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/to _voice (MP3).sh`

#### `_convert/to mp_3 VBR 192.sh`

- Description: !/usr/bin/env bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_convert/to mp_3 VBR 192.sh`

#### _git

#### `_git/commit and _push.sh`

- Description: Automates the process of committing and pushing changes in the current branch.
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_git/commit and _push.sh`

#### `_git/git _rename.sh`

- Description: Script to git mv a renamed file correctly
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_git/git _rename.sh`

#### `_git/git file _created date.sh`

- Description: This script retrieves the Git creation date of a selected file.
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_git/git file _created date.sh`

#### `_git/git helper in Joplin.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_git/git helper in Joplin.sh`

#### `_git/open-git-cola-here.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_git/open-git-cola-here.sh`

#### _install

#### `_install/_tarball-sudo.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_install/_tarball-sudo.sh`

#### `_install/_tarball.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_install/_tarball.sh`

#### `_install/check _sha256sum.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_install/check _sha256sum.sh`

#### hash check emblem._py

#### `_attributes/hash check emblem._py/_tag files against available hashes.sh`

- Description: A Nautilus script to validate files against their corresponding hash files (e.g., .md5sum, .sha256sum).
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_attributes/hash check emblem._py/_tag files against available hashes.sh`

#### `_attributes/hash check emblem._py/reset _emblems.sh`

- Description: This Nautilus script identifies files with specific extended attributes (e.g., `metadata::emblems`)
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_attributes/hash check emblem._py/reset _emblems.sh`

#### `_attributes/hash check emblem._py/reset emblems _recursively.sh`

- Description: This script is a wrapper that calls the "reset _emblems.sh" script recursively with the `-r` (recursive) option.
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./_attributes/hash check emblem._py/reset emblems _recursively.sh`

#### re_name

#### `re_name/S523 7d symbol to 7c hash.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./re_name/S523 7d symbol to 7c hash.sh`

#### `re_name/_remove date time.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./re_name/_remove date time.sh`

#### `re_name/add _creation date.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./re_name/add _creation date.sh`

#### `re_name/add date time _now.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./re_name/add date time _now.sh`

#### `re_name/based on _names.txt.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./re_name/based on _names.txt.sh`

#### `re_name/based on clipboard.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./re_name/based on clipboard.sh`

#### `re_name/based on filename w 7d symbol and year.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./re_name/based on filename w 7d symbol and year.sh`

#### `re_name/create _subfolder.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./re_name/create _subfolder.sh`

#### re_size

#### `re_size/compress _audio dir: speech.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./re_size/compress _audio dir: speech.sh`

#### `re_size/compress _audio: speech.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./re_size/compress _audio: speech.sh`

#### `re_size/resize J_PEG PNG: 1800x1800 150ppi.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./re_size/resize J_PEG PNG: 1800x1800 150ppi.sh`

#### `re_size/resize PDF: _ebook.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./re_size/resize PDF: _ebook.sh`

#### s_plit and merge

#### `s_plit and merge/merge PDFs and delete originals.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./s_plit and merge/merge PDFs and delete originals.sh`

#### `s_plit and merge/merge PDFs.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./s_plit and merge/merge PDFs.sh`

#### `s_plit and merge/split PDFs into pages.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./s_plit and merge/split PDFs into pages.sh`

#### `s_plit and merge/split-m4a-overlap.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./s_plit and merge/split-m4a-overlap.sh`

#### s_ystem

#### `s_ystem/2clipboard.sh`

- Description: Redirects stdin to clipboard using xclip, xsel, or wl-copy
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./s_ystem/2clipboard.sh`

#### `s_ystem/com_pare text-based.sh`

- Description: This script checks the number of input arguments and compares two files using kdiff3 if the correct number of arguments is provided.
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./s_ystem/com_pare text-based.sh`

#### `s_ystem/copy _cpu&mem info.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./s_ystem/copy _cpu&mem info.sh`

#### `s_ystem/copy _net info.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./s_ystem/copy _net info.sh`

#### `s_ystem/copy _sys info.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./s_ystem/copy _sys info.sh`

#### `s_ystem/copy _usage info.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./s_ystem/copy _usage info.sh`

#### `s_ystem/install available TTF & OTF _fonts.sh`

- Description: !/usr/bin/env bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./s_ystem/install available TTF & OTF _fonts.sh`

#### `s_ystem/rm pycharm lock.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./s_ystem/rm pycharm lock.sh`

#### `s_ystem/zenity_check.sh`

- Description: !/bin/bash
- Usage:
  1. Select files in Nautilus and execute the script from the Nautilus Scripts menu.
  2. Or run from a terminal: `./s_ystem/zenity_check.sh`

#### Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

- Fork the Project
- Create your Feature Branch (git checkout -b feature/AmazingFeature)
- Commit your Changes (git commit -m 'Add some AmazingFeature')
- Push to the Branch (git push origin feature/AmazingFeature)
- Open a Pull Request

#### License

Distributed under the MIT License. See LICENSE for more information.

#### Contact

Milan Berta - milan.berta@e.email

#### Acknowledgments
