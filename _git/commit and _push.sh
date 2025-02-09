#!/bin/bash

# Script to commit and push changes for the current active Git branch.
# Author: https://github.com/kofaysi/
# Description: Automates the process of committing and pushing changes in the current branch.
# Changelog:
# - [2025-01-25]: Refactored into modular functions for better maintainability.
#   - Import script_utils.sh for common functions.
#   - Output error messages to GUI output as well.
# - [2025-02-07]: Simplified to work only on the active branch.
#   - Includes untracked files in the commit process.
#   - Ensures staged changes are committed before unstaged changes.
#   - If unstaged changes remain after commit, prompts for another commit.
# - [2025-02-08]: Simplified dialog box. Removed summary field and kept only the description field.
#   - Added git reset on commit abort
#   - AI-generated commit message suggestion.

# Import common script functions if available
if [ -f "$HOME/.local/share/nautilus/scripts/script_utils.sh" ]; then
    source "$HOME/.local/share/nautilus/scripts/script_utils.sh"
else
    echo "Error: script_utils.sh not found. Exiting."
    exit 1
fi

# Get the name of the current branch
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# Function to generate and display AI commit suggestion separately
function show_ai_commit_suggestion() {
    local ai_suggestion=$(ai-commit --PROVIDER=ollama --MODEL=mistral --message-only | awk '/^------------------------------$/{flag=!flag; next} flag')
    zenity --info \
        --title="AI Commit Suggestion" \
        --text="$ai_suggestion" \
        --no-wrap
}

# Function to get commit message via Zenity
function get_commit_message() {
    local status="$1"
    show_ai_commit_suggestion  # Show AI commit suggestion first

    zenity --text-info \
        --title="Commit Message" \
        --text="Status for branch '$BRANCH_NAME':\n\n$status\n\nEnter a commit message:" \
        --editable \
        --width=600 --height=600
}


# Function to stash changes before pulling updates
function stash_changes_if_needed() {
    if ! git diff-index --quiet HEAD --; then
        git stash push --include-untracked -m "stash-$BRANCH_NAME"
    fi
}

# Function to pop the stash if changes were stashed earlier
function pop_stash_if_exists() {
    if git stash list | grep -q "stash-$BRANCH_NAME"; then
        git stash pop "$(git stash list | grep "stash-$BRANCH_NAME" | head -n1 | awk -F: '{print $1}')"
    fi
}

# Function to ensure the branch is tracking a remote branch
function ensure_branch_tracking() {
    if ! git rev-parse --abbrev-ref --symbolic-full-name "@{u}" >/dev/null 2>&1; then
        if git ls-remote --exit-code --heads origin "$BRANCH_NAME" >/dev/null 2>&1; then
            git branch --set-upstream-to=origin/"$BRANCH_NAME" "$BRANCH_NAME"
        else
            git push --set-upstream origin "$BRANCH_NAME"
        fi
    fi
}

# Function to commit changes
function commit_changes() {
    local commit_message
    local modified_files
    local selected_files

    while true; do
        # Get modified/untracked files
        modified_files=$(git status --short)

        # Exit if no files need committing
        if [ -z "$modified_files" ]; then
            output_message "Info" "No more changes to commit for branch '$BRANCH_NAME'."
            return 0
        fi

        # Prepare file list for Zenity checklist
        FILE_LIST=()
        while IFS= read -r line; do
            status=$(echo "$line" | awk '{print $1}')  # Extract status (M, A, D, ??)
            file=$(echo "$line" | awk '{$1=""; print $0}' | sed 's/^ *//')  # Extract filename
            file="${file#\"}"  # Remove leading quote
            file="${file%\"}"  # Remove trailing quote
            FILE_LIST+=("TRUE" "$status" "$file")
        done <<< "$modified_files"

        # Show Zenity checklist for file selection
        selected_files=$(zenity --list \
            --title="Select Files to Commit" \
            --text="Select files to stage for commit (branch '$BRANCH_NAME'):" \
            --checklist \
            --column="Select" --column="Status" --column="Filename" \
            "${FILE_LIST[@]}" \
            --separator="|" \
            --width=700 --height=500 \
            --multiple \
            --print-column=3)

        # Exit if no files were selected
        if [ -z "$selected_files" ]; then
            output_message "Error" "No files selected. Commit aborted."
            return 1
        fi

        # Stage only the selected files
        echo "$selected_files" | tr '|' '\n' | while IFS= read -r file; do
            if [ -n "$file" ]; then
                git add -- "$file"
            fi
        done

        # Get commit message
        commit_message=$(get_commit_message "$modified_files")
        if [ -z "$commit_message" ]; then
            git reset
            output_message "Error" "Commit aborted: No commit message provided."
            return 1
        fi

        # Commit changes
        if git commit -m "$commit_message"; then
            echo "Changes committed for branch '$BRANCH_NAME'."
        else
            output_message "Error" "No changes to commit after staging."
            return 1
        fi

        # Check if any changes remain after commit and repeat process
        remaining_files=$(git status --short)
        if [ -z "$remaining_files" ]; then
            break  # Exit loop if no changes remain
        fi
    done
}

# Main script execution
stash_changes_if_needed
ensure_branch_tracking
git pull --rebase
pop_stash_if_exists
commit_changes
git push origin "$BRANCH_NAME"
output_message "Info" "All changes have been committed and pushed for branch '$BRANCH_NAME'."
