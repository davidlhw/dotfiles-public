#!/usr/bin/env bash

set -e

echo '
      $$\            $$\      $$$$$$\  $$\ $$\                     
      $$ |           $$ |    $$  __$$\ \__|$$ |                    
 $$$$$$$ | $$$$$$\ $$$$$$\   $$ /  \__|$$\ $$ | $$$$$$\   $$$$$$$\ 
$$  __$$ |$$  __$$\\_$$  _|  $$$$\     $$ |$$ |$$  __$$\ $$  _____|
$$ /  $$ |$$ /  $$ | $$ |    $$  _|    $$ |$$ |$$$$$$$$ |\$$$$$$\  
$$ |  $$ |$$ |  $$ | $$ |$$\ $$ |      $$ |$$ |$$   ____| \____$$\ 
\$$$$$$$ |\$$$$$$  | \$$$$  |$$ |      $$ |$$ |\$$$$$$$\ $$$$$$$  |
 \_______| \______/   \____/ \__|      \__|\__| \_______|\_______/ '
echo ""

# location of the *full repo* (defaults to ~/.dotfiles)
DOTFILES_PATH="${DOTFILES_PATH:="$HOME/.dotfiles"}"
# location of this script (should be right next to all the other files, but we handle that next if it's not)
INSTALLER_PATH="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
GIT_CONFIGS_PATH=$DOTFILES_PATH/git/gitconfigs

# if this is a codespace, link automatically cloned dotfiles repo to the expected DOTFILES_PATH
# https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-personalization-for-codespaces#troubleshooting-dotfiles
if [[ "$CODESPACES" = "true" ]] && [[ -d /workspaces/.codespaces/.persistedshare/dotfiles ]]; then
    ln -sf /workspaces/.codespaces/.persistedshare/dotfiles "$DOTFILES_PATH"
fi

# clone this repo if this script is all by itself and/or we're not in the expected location
if [[ "$INSTALLER_PATH" != "$DOTFILES_PATH" ]] && [[ ! -d "$DOTFILES_PATH" ]]; then
    git clone https://github.com/davidlhw/dotfiles.git "$DOTFILES_PATH"

    echo "Successfully cloned the full repo to '$DOTFILES_PATH'"
    echo "Run './install.sh' from that directory to continue. Exiting now..."
    exit 0
fi

# this installation hinges on Homebrew, so make sure it's installed
if ! which -s brew; then
    # Install Homebrew
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
else
    brew update
fi

# set up symlinks from various default paths to files in this repo
if [[ ! -d ~/.config ]]; then
    mkdir -p ~/.config
fi
ln -sf "$DOTFILES_PATH/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_PATH/zsh/.zprofile" ~/.zprofile
ln -sf "$DOTFILES_PATH/git/.gitconfig" ~/.gitconfig
ln -sf "$DOTFILES_PATH/git/.gitignore_global" ~/.gitignore_global
ln -sf "$DOTFILES_PATH/starship/config.toml" ~/.config/starship.toml
for FILE in "$GIT_CONFIGS_PATH"/*; do
    if [ -f "$FILE" ]; then
        FILENAME=$(basename "$FILE")
        ln -sf "$GIT_CONFIGS_PATH/$FILENAME" "$HOME/$FILENAME"
    fi
done

# this file will be sourced by .zshrc for more sensitive variables/settings
touch ~/.zshrc.local

# prepare zinit manually
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# setup vim
VIM_RUNTIME="$HOME/.vim_runtime"
if [[ ! -d "$VIM_RUNTIME" ]]; then
    # shellcheck disable=SC1090,SC1091
    source "$DOTFILES_PATH/vim/install.sh"
fi

# the remainder of the setup tasks are OS-specific
if [[ "$OSTYPE" = "darwin"* ]]; then
    # final symlinks
    if [[ ! -d ~/.ssh ]]; then
        mkdir -p ~/.ssh && chmod 700 ~/.ssh
    fi
    ln -sf "$DOTFILES_PATH/ssh/.ssh/config" ~/.ssh/config
    ln -sf "$DOTFILES_PATH/Brewfile" ~/Brewfile

    # suppress terminal login banners
    touch ~/.hushlogin

    # shellcheck disable=SC1090,SC1091
    source "$DOTFILES_PATH/macos/macos.sh"
elif [[ "$OSTYPE" = "linux-gnu"* ]]; then
    # final symlinks
    ln -sf "$DOTFILES_PATH/nano/default.nanorc" ~/.nanorc

    # shellcheck disable=SC1090,SC1091
    source "$DOTFILES_PATH/linux/linux.sh"
else
    echo "I don't recognize this OS... skipping extra steps."
fi

# wow
echo ""
echo "🎉 It actually worked!"
echo "Log out and log back in (or just restart) to finish installing all ZSH features."
