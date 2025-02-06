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

#!/bin/bash

# Function to stash changes if there are unstaged modifications
function stash_changes_if_needed() {
    local branch_name="$1"
    if ! git diff-index --quiet HEAD --; then
        echo "### DEBUG: Stashing local changes for branch: $branch_name"
        git stash push -m "stash-$branch_name"
    fi
}

# Function to pop stash for a branch if it exists
function pop_stash_if_exists() {
    local branch_name="$1"
    if git stash list | grep -q "stash-$branch_name"; then
        echo "### DEBUG: Popping stash for branch: $branch_name"
        git stash pop "$(git stash list | grep "stash-$branch_name" | head -n1 | awk -F: '{print $1}')"
    else
        echo "### DEBUG: No stash to pop for branch: $branch_name"
    fi
}

# Function to switch branches safely
function switch_to_branch() {
    local branch_name="$1"
    if git checkout "$branch_name"; then
        echo "### DEBUG: Switched to branch: $branch_name"
        return 0
    else
        zenity --error --text="Error: Could not switch to branch $branch_name."
        return 1
    fi
}

# Function to ensure a branch is tracking a remote branch
function ensure_branch_tracking() {
    local branch_name="$1"

    # Check if the branch has an upstream
    if ! git rev-parse --abbrev-ref --symbolic-full-name "@{u}" >/dev/null 2>&1; then
        echo "### DEBUG: No upstream set for $branch_name. Setting upstream..."

        # Ensure remote branch exists before setting upstream
        if git ls-remote --exit-code --heads origin "$branch_name" >/dev/null 2>&1; then
            git branch --set-upstream-to=origin/"$branch_name" "$branch_name"
            echo "### DEBUG: Upstream set for branch: $branch_name"
        else
            echo "### DEBUG: Remote branch origin/$branch_name does not exist. Creating it..."
            git push --set-upstream origin "$branch_name"
        fi
    else
        echo "### DEBUG: Upstream already exists for $branch_name"
    fi
}

# Function to commit changes on a branch
function commit_changes_on_branch() {
    local branch_name="$1"

    echo "### DEBUG: Processing branch: $branch_name"

    # Stash local changes before switching
    stash_changes_if_needed "$(git rev-parse --abbrev-ref HEAD)"

    # Switch to the target branch
    if ! switch_to_branch "$branch_name"; then
        return 1
    fi

    # Ensure the branch has a tracking remote branch
    ensure_branch_tracking "$branch_name"

    # Pop stash only if it belongs to this branch
    pop_stash_if_exists "$branch_name"

    # Show updated status
    git status

    # Pull latest changes (default merge)
    echo "### DEBUG: Pulling latest changes for branch: $branch_name"
    if ! git pull; then
        zenity --error --text="Error pulling branch $branch_name. Please check conflicts or connectivity."
        return 1
    fi

    # Get the list of modified files and their statuses
    local modified_files=$(git status --short | grep -v '^??')

    # If no files are modified, exit early
    if [ -z "$modified_files" ]; then
        echo "### DEBUG: No modified files found for branch: $branch_name"
        zenity --info --text="No changes to commit for branch $branch_name."
        return 0
    fi

    # Prepare the file list for Zenity checklist (preselected by default)
    FILE_LIST=()
    while IFS= read -r line; do
        status=$(echo "$line" | awk '{print $1}')  # Extract status (e.g., M, A, D)
        file=$(echo "$line" | awk '{$1=""; print $0}' | sed 's/^ *//')  # Extract filename

        FILE_LIST+=("TRUE" "$file" "$status")  # Preselect all files
    done <<< "$modified_files"

    # Show Zenity checklist for file selection
    SELECTED_FILES=$(zenity --list \
        --title="Select Files to Commit" \
        --text="Select files to stage for commit (branch: $branch_name):" \
        --checklist \
        --column="Select" --column="Filename" --column="Status" \
        "${FILE_LIST[@]}" \
        --separator="|" \
        --width=700 --height=500 \
        --multiple)

    # Check if user canceled or selected nothing
    if [ -z "$SELECTED_FILES" ]; then
        zenity --error --text="No files selected. Commit aborted."
        echo "### DEBUG: No files selected, skipping commit."
        return 1
    fi

    # Stage only the selected files (Handling spaces properly)
    echo "### DEBUG: Staging selected files..."
    echo "$SELECTED_FILES" | tr '|' '\n' | while IFS= read -r file; do
        # Remove extra quotes from filenames
        clean_file=$(echo "$file" | sed 's/^"\(.*\)"$/\1/')

        if [ -n "$clean_file" ]; then
            git add -- "$clean_file"  # Use -- to handle filenames safely
            echo "### DEBUG: Added file: '$clean_file'"
        else
            echo "### DEBUG: Skipped empty filename."
        fi
    done


    # Get commit message
    local status=$(git status --short | sed '/^$/d')
    local commit_message="${COMMIT_MESSAGE:-$(get_commit_message "$branch_name" "$status")}"
    if [ -z "$commit_message" ]; then
        zenity --error --text="Commit aborted: No commit message provided."
        return 1
    fi

    summary=$(echo "$commit_message" | head -1 | cut -d'|' -f1)
    description=$(echo "$commit_message" | cut -d'|' -f2-)

    # Commit changes
    echo "### DEBUG: Committing changes..."
    if git commit -m "$summary" -m "$(echo -e "$description" | sed 's/\n/\" -m \"/g')"; then
        echo "Changes committed for branch $branch_name."
    else
        zenity --error --text="No changes to commit after staging."
        return 1
    fi

    # Push changes
    echo "### DEBUG: Pushing changes..."
    if git push origin "$branch_name"; then
        echo "Changes pushed to remote repository for branch $branch_name."
    else
        zenity --error --text="Error pushing changes for branch $branch_name."
        return 1
    fi

    # Stash any new changes before switching back
    stash_changes_if_needed "$branch_name"

    echo "### DEBUG: Finished processing branch: $branch_name"
    return 0
}




# Function to process all branches and restore the original branch
function process_all_branches() {
    local original_branch=$(git rev-parse --abbrev-ref HEAD)
    echo "### DEBUG: Starting branch loop from: $original_branch"

    local branches=$(git branch --list | sed 's/^[* ] //')

    for branch in $branches; do
        commit_changes_on_branch "$branch"
    done

    # Switch back to the original branch
    echo "### DEBUG: Returning to original branch: $original_branch"
    switch_to_branch "$original_branch"

    # Pop stash if it existed before starting
    pop_stash_if_exists "$original_branch"

    echo "### DEBUG: All branches processed. Back on '$original_branch'."
}


# Main script execution
ensure_display
parse_arguments "$@"
process_all_branches
output_message "Info" "All branches have been processed."

