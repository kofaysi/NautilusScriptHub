#!/bin/bash

# Function to get commit message via Zenity
function get_commit_message() {
    local branch_name="$1"
    local status="$2"
    zenity --entry --title="Commit Message" --text="Status for branch '$branch_name':\n\n$status\n\nEnter a commit message for branch '$branch_name':"
}

# Ensure DISPLAY is set, if not, set it to :0
if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0
fi

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

# Function to commit changes on the current branch
function commit_changes_on_branch() {
    local branch_name="$1"
    git checkout "$branch_name"

    # Check if the branch exists on the remote
    if git ls-remote --exit-code --heads origin "$branch_name"; then
        # Pull the latest changes from the remote repository
        if git pull origin "$branch_name"; then
            echo "Successfully pulled from remote repository for branch $branch_name."
        else
            echo "Error pulling from remote repository for branch $branch_name. Please check for conflicts or connectivity issues."
            return 1
        fi
    else
        echo "Branch $branch_name does not exist on the remote. Creating it."
        git push --set-upstream origin "$branch_name"
    fi

    # Check for any changes in the working directory or staging area
    if git diff-index --quiet HEAD -- && git diff --staged --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
        echo "No changes to commit for branch $branch_name."
        return 0
    fi

    # Get the status and format it
    local status=$(git status --short | sed '/^$/d')
    
    # If no commit message is provided, use Zenity to get one
    local commit_message="$COMMIT_MESSAGE"
    if [ -z "$commit_message" ]; then
        commit_message=$(get_commit_message "$branch_name" "$status")
        if [ -z "$commit_message" ]; then
            zenity --error --text="Commit aborted: No commit message provided for branch $branch_name."
            return 1
        fi
    fi

    # Add all modified files to the staging area
    git add .

    # Commit the changes with the provided message
    if git commit -m "$commit_message"; then
        echo "Changes successfully committed for branch $branch_name."
    else
        echo "No changes were detected to commit after staging for branch $branch_name."
        return 0
    fi

    # Push the changes to the remote repository
    if git push origin "$branch_name"; then
        echo "Changes successfully pushed to remote repository for branch $branch_name."
    else
        echo "Error pushing changes to remote repository for branch $branch_name. Please check your permissions or network connection."
        return 1
    fi

    echo "Branch $branch_name has been updated successfully."
    return 0
}

# Capture the name of the current branch
original_branch=$(git rev-parse --abbrev-ref HEAD)

# Get the list of all branches
branches=$(git branch --list | sed 's/^[* ] //')

# Iterate over each branch and commit changes
for branch in $branches; do
    commit_changes_on_branch "$branch"
done

# Switch back to the original branch
git checkout "$original_branch"
echo "Switched back to the original branch '$original_branch'."

# Confirm the update
echo "All branches have been processed."

