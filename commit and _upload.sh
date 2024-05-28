#!/bin/bash

# Function to get commit message via Zenity
function get_commit_message() {
    zenity --entry --title="Commit Message" --text="Enter the commit message:"
}

# Ensure DISPLAY is set, if not, set it to :0
if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0
fi

# Debugging information
echo "Running script as user: $(whoami)"
echo "Current directory: $(pwd)"
echo "Display environment: $DISPLAY"

# Initialize variables
COMMIT_MESSAGE=""

# Parse arguments
while getopts ":m:" opt; do
  case $opt in
    m)
      COMMIT_MESSAGE="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Pull the latest changes from the remote repository
if git pull origin main; then
    echo "Successfully pulled from remote repository."
else
    echo "Error pulling from remote repository. Please check for conflicts or connectivity issues."
    exit 1
fi

# Check for any changes in the working directory or staging area
if git diff-index --quiet HEAD -- && git diff --staged --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "No changes to commit. Exiting."
    exit 0
fi

# If no commit message is provided, use zenity to get one
if [ -z "$COMMIT_MESSAGE" ]; then
    COMMIT_MESSAGE=$(get_commit_message)
    if [ -z "$COMMIT_MESSAGE" ]; then
        zenity --error --text="Commit aborted: No commit message provided."
        exit 1
    fi
fi

# Add all modified files to the staging area
git add .

# Commit the changes with the provided message
if git commit -m "$COMMIT_MESSAGE"; then
    echo "Changes successfully committed."
else
    echo "No changes were detected to commit after staging."
    exit 0
fi

# Push the changes to the remote repository
if git push origin main; then
    echo "Changes successfully pushed to remote repository."
else
    echo "Error pushing changes to remote repository. Please check your permissions or network connection."
    exit 1
fi

# Confirm the update
echo "Repository has been updated successfully."

