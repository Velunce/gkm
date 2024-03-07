#!/usr/bin/env sh

PROJECT_ENTRY="gkm.sh"

DEFAULT_SSH_DIR="$HOME/.ssh"

PS3='Please select the key: '
options=()

for entry in "$DEFAULT_SSH_DIR"/*.pub
do
    IFS='/' read -r -a array <<< "$entry"
    options+=(${array[4]})
done

select opt in "${options[@]}"
do
    case $opt in
        ${options[$REPLY-1]})
            if [ ! $opt ]; 
            then
                exit;
            else
                ssh-add -D
                ssh-add "$DEFAULT_SSH_DIR"/${opt%.*}
                exit;
            fi;
            break;;
    esac
done
