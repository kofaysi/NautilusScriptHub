#!/bin/bash

# Script to commit and push changes accross multiple git branches.
# Author: https://github.com/kofaysi/
# Description: # This script automates the process of committing and pushing changes across multiple Git branches. It allows for dynamic commit messages via Yad and handles branch synchronization with the remote repository.
# Changelog:
# - [2025-01-25]: Refactored into modular functions for better maintainability.
# 	- Import script_utils.sh for common functions.
# 	- Ouput Error messages to GUI ouput as well. 

# Function to ensure DISPLAY is set
function ensure_display() {
    if [ -z "$DISPLAY" ]; then
        export DISPLAY=:0
    fi
}

# import common script functions
if [ -f ~/.local/share/nautilus/scripts/script_utils.sh ]; then
    source ~/.local/share/nautilus/scripts/script_utils.sh
else
    echo "Error: script_utils.sh not found. Exiting."
    exit 1
fi

# Function to parse arguments
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

# Function to check if a branch exists on remote and update it
function update_branch_from_remote() {
    local branch_name="$1"
    if git ls-remote --exit-code --heads origin "$branch_name"; then
        if ! git pull origin "$branch_name"; then
            output_message "Error" "Error pulling branch $branch_name. Please check conflicts or connectivity."
            return 1
        fi
    else
        echo "Branch $branch_name does not exist on remote. Creating it."
        git push --set-upstream origin "$branch_name"
    fi
}

# Function to commit changes on a branch
function commit_changes_on_branch() {
    local branch_name="$1"
    git checkout "$branch_name"

    # Update branch from remote
    update_branch_from_remote "$branch_name" || return 1

    # Check for changes
    if git diff-index --quiet HEAD -- && git diff --staged --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
        echo "No changes to commit for branch $branch_name."
        return 0
    fi

    # Get git status and commit message
    local status=$(git status --short | sed '/^$/d')
    local commit_message="${COMMIT_MESSAGE:-$(get_commit_message "$branch_name" "$status")}"
    if [ -z "$commit_message" ]; then
        output_message "Error" "Commit aborted: No commit message provided for branch $branch_name."
        return 1
    fi
    
    summary=$(echo "$commit_message" | head -1 | cut -d'|' -f1)
		description=$(echo "$commit_message" | cut -d'|' -f2-)

    # Stage and commit changes
    git add .
    # The commit message contains a vertical bar at the end, trim it. The commit messagem may contain \n as newline separators, chop the message to multiple -m messages
    #if git commit -m "$(echo -e "$commit_message" | sed 's/|$//; s/\n/\" -m \"/g')"; then # for yad
    if git commit -m "$summary" -m "$(echo -e "$description" | sed 's/\n/\" -m \"/g')"; then # for zenity
        echo "Changes committed for branch $branch_name."
    else
        echo "No changes to commit after staging for branch $branch_name."
        return 0
    fi

    # Push changes
    if git push origin "$branch_name"; then
        echo "Changes pushed to remote repository for branch $branch_name."
    else
        output_message "Error" "Error pushing changes to remote repository for branch $branch_name."
        return 1
    fi

    echo "Branch $branch_name updated successfully."
    return 0
}

# Function to process all branches
function process_all_branches() {
    local original_branch=$(git rev-parse --abbrev-ref HEAD)
    local branches=$(git branch --list | sed 's/^[* ] //')

    for branch in $branches; do
        commit_changes_on_branch "$branch"
    done

    # Switch back to the original branch
    git checkout "$original_branch"
    echo "Switched back to original branch '$original_branch'."
}

# Main script execution
ensure_display
parse_arguments "$@"
process_all_branches
output_message "Info" "All branches have been processed."

