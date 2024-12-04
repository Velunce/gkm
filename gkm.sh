#!/usr/bin/env sh

# Function to list SSH keys with associated username and email
function get_ssh_key_list {
    echo "(Listing all SSH keys with details in the .ssh folder of the current user)\n"

    keys=(~/.ssh/*.pub)

    # Check if no SSH keys are found
    if [ ! -e "${keys[0]}" ]; then
        echo "No SSH keys found in ~/.ssh"
        return
    fi

    # Define colors and styles
    BLUE_BG="\033[44m"   # Blue background for active SSH key
    RESET="\033[0m"      # Reset to default (no color/background)
    BOLD="\033[1m"       # Bold text for header

    # Initialize variables to track maximum lengths
    max_username_length=0
    max_email_length=0
    max_keyfile_length=0

    # First pass to find maximum lengths
    for key_file in "${keys[@]}"; do
        email=$(awk '{print $NF}' "$key_file" 2>/dev/null)
        email="${email:-(No email found)}"  # Default message if email is not found
        username=$(basename "$key_file" | sed -e 's/\.pub//' -e 's/^id_[a-zA-Z0-9]*_//')

        # Update maximum lengths
        (( ${#username} > max_username_length )) && max_username_length=${#username}
        (( ${#email} > max_email_length )) && max_email_length=${#email}
        (( ${#key_file} > max_keyfile_length )) && max_keyfile_length=${#key_file}
    done

    # Set fixed widths based on maximum lengths
    username_width=$(( max_username_length + 2 ))
    email_width=$(( max_email_length + 2 ))
    keyfile_width=$(( max_keyfile_length + 2 ))
    total_width=$(( 4 + username_width + email_width + keyfile_width ))

    actived_ssh_email=$(ssh-add -L | awk '{print $NF}')

    # Print table header (with bold and underline)
    printf "${BOLD}%-4s %-${username_width}s %-${email_width}s %-${keyfile_width}s${RESET}\n" "No" "Username" "Email" "Key File"
    printf "${BOLD}%-${total_width}s${RESET}\n" "$(printf '%0.s-' $(seq 1 $total_width))"

    # Loop to list SSH keys with numbers starting from 1, along with username and email
    for i in "${!keys[@]}"; do
        key_file="${keys[$i]}"
        email=$(awk '{print $NF}' "$key_file" 2>/dev/null)
        email="${email:-(No email found)}"  # Default message if email is not found

        # Get the username from the filename
        username=$(basename "$key_file" | sed -e 's/\.pub//' -e 's/^id_[a-zA-Z0-9]*_//')

        # Extract only the file name without path
        key_filename=$(basename "$key_file")

        # Check if the key is active (replace "active_key_name.pub" with your actual active key)
        if [[ "$email" == "$actived_ssh_email" ]]; then
            printf "${BOLD}${BLUE_BG}%-4s %-$((${username_width}))s %-$((${email_width}))s %-$((${keyfile_width}))s${RESET}\n" "$((i + 1))" "$username" "$email" "$key_filename"
        else
            printf "%-4s %-${username_width}s %-${email_width}s %-${keyfile_width}s\n" "$((i + 1))" "$username" "$email" "$key_filename"
        fi
    done
}


# Function to switch SSH key based on index or username
function set_ssh_key {
    # Check if input is a number (index) or a string (username)
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        # Handle case for index
        keys=($HOME/.ssh/*.pub)

        # Convert input to zero-based index
        key_index=$(( $1 - 1 ))

        # Check if the user provided a valid index
        if [ -z "${keys[$key_index]}" ]; then
            echo "Invalid key number."
            return
        fi

        selected_key="${keys[$key_index]}"

        private_key="${selected_key%.pub}"

    else
        # Handle case for username
        private_key=$(find ~/.ssh -name "id_*$1" -not -name "*.pub")

        # Check if we found a key matching the username
        if [ -z "$private_key" ]; then
            echo "No SSH key found for username: $1."
            return
        fi
        selected_key="${private_key}.pub"
    fi

    # Check if the corresponding private key exists
    if [ -f "$private_key" ]; then
        # Set the SSH agent to use the selected key
        ssh-add -D
        ssh-add "$private_key"
        echo "Switched to SSH key: $private_key"
    else
        echo "Private key not found for: $private_key"
    fi
}

# Function to generate a new SSH key
function ssh_key_generate {
    read -p "Enter username for the SSH key: " username
    read -p "Enter email for the SSH key: " email

    # Check if the username and email are not empty
    if [ -z "$username" ] || [ -z "$email" ]; then
        echo "Username and email cannot be empty."
        return
    fi

    # Ask the user to select an SSH key type
    echo "Select SSH key type to generate:"
    echo "1) RSA (default)"
    echo "2) Ed25519"
    echo "3) ECDSA"
    read -p "Enter the number of the key type: " key_type

    case $key_type in
        2)
            key_type="ed25519"
            ;;
        3)
            key_type="ecdsa"
            ;;
        *)
            key_type="rsa"
            ;;
    esac

    # Generate the SSH key based on the user's choice
    if [ "$key_type" == "rsa" ]; then
        ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/id_rsa_$username -N ""
    elif [ "$key_type" == "ed25519" ]; then
        ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519_$username -N ""
    elif [ "$key_type" == "ecdsa" ]; then
        ssh-keygen -t ecdsa -b 521 -C "$email" -f ~/.ssh/id_ecdsa_$username -N ""
    fi

    if [ $? -eq 0 ]; then
        echo "New SSH key generated: ~/.ssh/id_${key_type}_$username"
    else
        echo "Failed to generate SSH key."
    fi
}

# Function to remove an SSH key by index
function git_key_remove {
    get_ssh_key_list
    read -p "Enter the index of the SSH key to remove: " key_index

    # Convert input to zero-based index
    key_index=$((key_index - 1))

    keys=(~/.ssh/*.pub)
    if [ -z "${keys[$key_index]}" ]; then
        echo "Invalid key number."
        return
    fi

    selected_key="${keys[$key_index]}"
    private_key="${selected_key%.pub}"

    # Remove both the public and private key
    rm -f "$private_key" "$selected_key"

    if [ $? -eq 0 ]; then
        echo "Removed SSH key: $private_key and $selected_key"
    else
        echo "Failed to remove SSH key."
    fi
}

# Function to uninstall gkm and remove all SSH keys
function gkm_uninstall {
    # First confirmation for uninstalling gkm and removing ~/.gkm folder
    read -p "Are you sure you want to uninstall gkm? This will remove the ~/.gkm folder and gkm alias. (Y/n): " confirm_uninstall
    confirm_uninstall=${confirm_uninstall:-y}  # Default to 'y' if no input

    if [ "$confirm_uninstall" == "y" ]; then
        # Second confirmation before deleting SSH keys
        read -p "Are you sure you want to delete all SSH keys? This action is irreversible. (y/N): " confirm_delete
        confirm_delete=${confirm_delete:-n}  # Default to 'n' if no input

        if [ "$confirm_delete" == "y" ]; then
            rm -f ~/.ssh/*
            echo "All SSH keys have been removed."
        else
            echo "SSH keys removal skipped."
        fi
        # Remove ~/.gkm folder and gkm alias (default action)
        rm -rf ~/.gkm
        unset gkm
        echo "gkm folder and alias have been removed."
    else
        echo "Uninstall canceled."
    fi
}

# Function to display all available commands
function gkm_help {
    echo "Usage: gkm [command]"
    echo ""
    echo "Commands:"
    echo "list        - List all available SSH keys along with username and email."
    echo "use <index|username> - Switch to a specific SSH key by index or username."
    echo "new    - Generate a new SSH key (prompts for username, email, and key type)."
    echo "remove      - Remove an SSH key by its index."
    echo "uninstall   - Uninstall gkm script and remove all SSH keys."
}

# Main command handler
case $1 in
    "ls" | "list")
        get_ssh_key_list
        ;;
    "use")
        if [ -z "$2" ]; then
            echo "Please provide the key number or username to use"
        else
            set_ssh_key $2
        fi
        ;;
    "new")
        ssh_key_generate
        ;;
    "remove")
        git_key_remove
        ;;
    "uninstall")
        gkm_uninstall
        ;;
    *)
        gkm_help
        ;;
esac
