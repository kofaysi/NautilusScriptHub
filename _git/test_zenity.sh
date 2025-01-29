#!/bin/bash

# Function to get commit message via Zenity
function get_commit_message() {
    local dummy_branch="dummy-branch"
    local dummy_status="Dummy status: Modified files here"
    
    local commit_data=$(~/./Downloads/zenity-forms_text_info/build/src/zenity  --forms \
        --title="Commit Message" \
        --text="Add commit message" \
        --add-entry="Summary" \
        --add-text-info="Description" \
        --width=300 --height=400)
    echo "$commit_data"
}

# Get commit message
commit_message=$(get_commit_message)
if [ -z "$commit_message" ]; then
    echo "Error: Commit aborted. No commit message provided."
    exit 1
fi

echo "Commit message:"
echo $commit_message

# Extract summary and description
summary=$(echo "$commit_message" | head -1 | cut -d'|' -f1)
description=$(echo "$commit_message" | cut -d'|' -f2-)

echo "Summary:"
echo $summary

echo "Description:"
echo $description

# Format commit message properly
commit_command="git commit -m \"$summary\" -m \"$(echo "$description" | sed ':a;N;$!ba;s/\n/" -m "/g')\""
echo "Generated commit command: $commit_command"


