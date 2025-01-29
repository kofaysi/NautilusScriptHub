#!/bin/bash
echo "PATH: $PATH" > ~/nautilus-path.log
which zenity >> ~/nautilus-path.log
zenity --version >> ~/nautilus-path.log
