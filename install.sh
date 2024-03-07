#!/usr/bin/env sh
PROJECT_NAME="gkm.sh"

DEFAULT_COMMAND="gkm"
GKM_GITHUB_REPO="gkm.sh"

SCRIPT_PATH="$DEFAULT_INSTALL_HOME/$PROJECT_NAME"

DEFAULT_INSTALL_HOME="$HOME/.$DEFAULT_COMMAND"

gkm_echo() {
  command printf %s\\n "$*" 2>/dev/null
}

mkdir -p "$DEFAULT_INSTALL_HOME"
if [ -f "$DEFAULT_INSTALL_HOME/gkm.sh" ]; then
    gkm_echo "=> gkm is already installed in $DEFAULT_INSTALL_HOME, trying to update the script"
else
    gkm_echo "=> Downloading gkm as script to '$DEFAULT_INSTALL_HOME'"
    # chmod +x $SCRIPT_PATH
    # gedit ~/.bashrc
    # alias ${DEFAULT_COMMAND}=
fi
