#!/bin/bash

# Script to commit and push changes across multiple git branches.
# Author: https://github.com/kofaysi/
# Description: This script automates the process of committing and pushing changes across multiple Git branches.
# It allows for dynamic commit messages via Yad and handles branch synchronization with the remote repository.
# Changelog:
# - [2025-01-25]: Refactored into modular functions for better maintainability.
#   - Import script_utils.sh for common functions.
#   - Output error messages to GUI output as well.

# Function to ensure DISPLAY is set (necessary for GUI tools like Zenity)
function ensure_display() {
    if [ -z "$DISPLAY" ]; then
        export DISPLAY=:0
    fi
}

# Import common script functions if available
if [ -f ~/.local/share/nautilus/scripts/script_utils.sh ]; then
    source ~/.local/share/nautilus/scripts/script_utils.sh
else
    echo "Error: script_utils.sh not found. Exiting."
    exit 1
fi

# Function to parse script arguments
function parse_arguments() {
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
}

# Function to get commit message via Yad
function get_commit_message() {
    local branch_name="$1"
    local status="$2"
### zenity
		zenity  --forms \
		        --title="Commit Message" \
		        --text="Status for branch '$branch_name':\n\n$status\n\nEnter a commit message for branch '':" \
		        --add-entry="Summary" \
		        --add-text-info="Description" \
		        --width=600 --height=600

### yad
#    yad --title="Commit Message" \
#        --form \
#        --width=600 \
#        --height=400 \
#        --field="Commit Message (status prefilled.
#Multiline message is split into multi -m messages).
#For better commit messages visit https://www.conventionalcommits.org/":TXT "$status"
}


# Function to stash changes if there are unstaged modifications
function stash_changes_if_needed() {
    local branch_name="$1"
    if ! git diff-index --quiet HEAD --; then
        git stash push -m "stash-$branch_name"
    fi
}

# Function to pop stash for a branch if it exists
function pop_stash_if_exists() {
    local branch_name="$1"
    if git stash list | grep -q "stash-$branch_name"; then
        git stash pop "$(git stash list | grep "stash-$branch_name" | head -n1 | awk -F: '{print $1}')"
    fi
}

# Function to switch to a given branch
function switch_to_branch() {
    local branch_name="$1"
    if git checkout "$branch_name"; then
        return 0
    else
        output_message "Error" "Could not switch to branch '$branch_name'."
        return 1
    fi
}

# Function to ensure a branch is tracking a remote branch
function ensure_branch_tracking() {
    local branch_name="$1"

    # Check if the branch has an upstream
    if ! git rev-parse --abbrev-ref --symbolic-full-name "@{u}" >/dev/null 2>&1; then
        # Set the upstream tracking branch if it exists remotely
        if git ls-remote --exit-code --heads origin "$branch_name" >/dev/null 2>&1; then
            git branch --set-upstream-to=origin/"$branch_name" "$branch_name"
        else
            # If the remote branch does not exist, create it
            git push --set-upstream origin "$branch_name"
        fi
    fi
}

# Function to commit changes on a given branch
function commit_changes_on_branch() {
    local branch_name="$1"

    # Stash any local changes before switching branches
    stash_changes_if_needed "$(git rev-parse --abbrev-ref HEAD)"

    # Switch to the target branch
    if ! switch_to_branch "$branch_name"; then
        return 1
    fi

    # Ensure the branch has an upstream tracking remote branch
    ensure_branch_tracking "$branch_name"

    # Pull latest changes BEFORE popping the stash (to prevent divergence issues)
    if ! git pull --rebase; then
        output_message "Error" "Error pulling branch '$branch_name'. Please check conflicts or connectivity."
        return 1
    fi

    # Restore stashed changes for this branch if available
    pop_stash_if_exists "$branch_name"

    # Get a list of modified files (excluding untracked files)
    local modified_files=$(git status --short | grep -v '^??')

    # Exit if there are no modified files
    if [ -z "$modified_files" ]; then
        output_message "Info" "No changes to commit for branch '$branch_name'."
        return 0
    fi

    # Prepare file list for Zenity checklist (preselecting all files)
    FILE_LIST=()
    while IFS= read -r line; do
        status=$(echo "$line" | awk '{print $1}')  # Extract status (e.g., M, A, D)
        file=$(echo "$line" | awk '{$1=""; print $0}' | sed 's/^ *//')  # Extract filename
        FILE_LIST+=("TRUE" "$file" "$status")
    done <<< "$modified_files"

    # Show Zenity checklist for file selection
    SELECTED_FILES=$(zenity --list \
        --title="Select Files to Commit" \
        --text="Select files to stage for commit (branch '$branch_name'):" \
        --checklist \
        --column="Select" --column="Filename" --column="Status" \
        "${FILE_LIST[@]}" \
        --separator="|" \
        --width=700 --height=500 \
        --multiple)

    # Exit if no files were selected
    if [ -z "$SELECTED_FILES" ]; then
        output_message "Error" "No files selected. Commit aborted."
        return 1
    fi

    # Stage only the selected files (handling filenames with spaces correctly)
    echo "$SELECTED_FILES" | tr '|' '\n' | while IFS= read -r file; do
        clean_file=$(echo "$file" | sed 's/^"\(.*\)"$/\1/')
        if [ -n "$clean_file" ]; then
            git add -- "$clean_file"
        fi
    done

    # Get commit message
    local status=$(git status --short | sed '/^$/d')
    local commit_message="${COMMIT_MESSAGE:-$(get_commit_message "$branch_name" "$status")}"
    if [ -z "$commit_message" ]; then
        output_message "Error" "Commit aborted: No commit message provided."
        return 1
    fi

    summary=$(echo "$commit_message" | head -1 | cut -d'|' -f1)
    description=$(echo "$commit_message" | cut -d'|' -f2-)

    # Commit the selected files
    if git commit -m "$summary" -m "$(echo -e "$description" | sed 's/\n/\" -m \"/g')"; then
        echo "Changes committed for branch '$branch_name'."
    else
        output_message "Error" "No changes to commit after staging."
        return 1
    fi

    # Push changes to the remote repository
    if ! git push origin "$branch_name"; then
        output_message "Error" "Error pushing changes for branch '$branch_name'."
        return 1
    fi

    # Stash any new changes before switching back
    stash_changes_if_needed "$branch_name"

    return 0
}

# Function to process all branches and restore the original branch
function process_all_branches() {
    local original_branch=$(git rev-parse --abbrev-ref HEAD)
    local branches=$(git branch --list | sed 's/^[* ] //')

    # Process each branch sequentially
    for branch in $branches; do
        commit_changes_on_branch "$branch"
    done

    # Return to the original branch
    switch_to_branch "$original_branch"

    # Restore original branch's stash if it exists
    pop_stash_if_exists "$original_branch"
}

# Main script execution
ensure_display
parse_arguments "$@"
process_all_branches
output_message "Info" "All branches have been processed."
