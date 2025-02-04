#!/bin/bash

# Identify shared account by finding home directories with setgid bit (+s) set
echo "Searching for shared accounts with setgid bit set..."
SHARED_ACCOUNTS=$(sudo find /home -maxdepth 1 -type d -perm -2000 -exec basename {} \;)

if [[ -z "$SHARED_ACCOUNTS" ]]; then
    echo "No shared account found. Prompting user for creation."
    SHARED_ACCOUNT=$(zenity --entry --title="Create Shared Account" --text="No shared account has been found. Enter the name for the shared account:" --entry-text="shared")
    SHARED_ACCOUNT=${SHARED_ACCOUNT:-shared}
    echo "Creating shared user and group: $SHARED_ACCOUNT"
    sudo useradd -m "$SHARED_ACCOUNT"
    sudo groupadd -f "$SHARED_ACCOUNT"
    sudo chmod 2770 "/home/$SHARED_ACCOUNT"
elif [[ $(echo "$SHARED_ACCOUNTS" | wc -w) -eq 1 ]]; then
    SHARED_ACCOUNT="$SHARED_ACCOUNTS"
    echo "Only one shared account found: $SHARED_ACCOUNT. Proceeding with management."
else
    echo "Multiple shared accounts found. Prompting user for selection."
    SHARED_ACCOUNT=$(zenity --list --title="Manage Shared Account" --text="Select the shared account to manage:" --column="Shared Account" $SHARED_ACCOUNTS)
    if [[ -z "$SHARED_ACCOUNT" ]]; then
        zenity --warning --title="No Selection" --text="No shared account selected. Exiting."
        exit 1
    fi
fi

echo "Fetching system users excluding the shared account..."
USERS=$(awk -F: '$3 >= 1000 && $3 < 60000 {print $1}' /etc/passwd | grep -v "^$SHARED_ACCOUNT$")
echo "System users: $USERS"

echo "Fetching users in shared group..."
GROUP_USERS=$(getent group "$SHARED_ACCOUNT" | cut -d: -f4 | tr ',' ' ')
echo "Users in shared group: $GROUP_USERS"

CHECKLIST=""
for USER in $USERS; do
    if [[ " $GROUP_USERS " =~ " $USER " ]]; then
        CHECKLIST+="TRUE $USER "
    else
        CHECKLIST+="FALSE $USER "
    fi
done

SELECTED_USERS=$(zenity --list --title="Modify Group Content" --text="Add or remove users in the \'$SHARED_ACCOUNT\' group:" \
    --checklist --column="Select" --column="User" $CHECKLIST --separator=" ")

for USER in $USERS; do
    if [[ " $SELECTED_USERS " =~ " $USER " ]]; then
        if [[ " $GROUP_USERS " =~ " $USER " ]]; then
            echo "$USER is already in the group, skipping modification."
        else
            echo "Adding $USER to group and creating symlink."
            sudo usermod -aG "$SHARED_ACCOUNT" "$USER"
            sudo ln -sf "/home/$SHARED_ACCOUNT" "/home/$USER/Shared"
        fi
    else
        if [[ " $GROUP_USERS " =~ " $USER " ]]; then
            echo "Removing $USER from group and deleting symlink."
            SHARED_LINK=$(sudo find "/home/$USER" -maxdepth 1 -type l -lname "/home/$SHARED_ACCOUNT" 2>/dev/null)
            sudo gpasswd -d "$USER" "$SHARED_ACCOUNT"
            sudo rm -f "$SHARED_LINK"
        else
            echo "$USER was not in the shared group, skipping modification."
        fi
    fi
done

echo "Checking if any users remain in the shared group..."
REMAINING_USERS=$(getent group "$SHARED_ACCOUNT" | cut -d: -f4)
if [[ -z "$REMAINING_USERS" ]]; then
    zenity --question --title="Remove Shared Account" --text="No users remain in the shared group. Remove shared account and its home?"
    if [[ $? -eq 0 ]]; then
        echo "Removing shared user, home directory, and group."
        sudo userdel "$SHARED_ACCOUNT"
        sudo rm -rf "/home/$SHARED_ACCOUNT"
        if getent group "$SHARED_ACCOUNT" >/dev/null; then
            echo "Removing group: $SHARED_ACCOUNT"
            sudo groupdel "$SHARED_ACCOUNT"
        else
            echo "Group $SHARED_ACCOUNT does not exist, skipping removal."
        fi
        zenity --info --title="Cleanup Complete" --text="Shared account and its home have been removed."
    fi
fi
