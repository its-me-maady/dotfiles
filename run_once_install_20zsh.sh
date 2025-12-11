#!/bin/bash
# run_once_20_install_zsh.sh

echo "--- Setting up Zsh Ecosystem ---"

# 1. Install Oh My Zsh (Unattended)
# We check if the folder exists to avoid errors on repeated runs
OMZ_DIR="$HOME/.oh-my-zsh"

if [ ! -d "$OMZ_DIR" ]; then
    echo "Installing Oh My Zsh..."
    # The "" --unattended flag prevents it from starting zsh immediately and stopping the script
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
 else
    echo "✅ Oh My Zsh is already installed."
fi

# Define the custom folder (Standard OMZ location)
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# 2. Install Powerlevel10k Theme
P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "✅ Powerlevel10k is already installed."
fi

# 3. Install Plugins
# These are the two most common plugins. Add more here if needed.

# Autosuggestions (Gray text completion)
AUTO_DIR="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
if [ ! -d "$AUTO_DIR" ]; then
    echo "Installing Zsh Autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTO_DIR"
else
    echo "✅ Zsh Autosuggestions installed."
fi

# Syntax Highlighting (Green/Red command text)
SYNTAX_DIR="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
if [ ! -d "$SYNTAX_DIR" ]; then
    echo "Installing Zsh Syntax Highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAX_DIR"
else
    echo "✅ Zsh Syntax Highlighting installed."
fi

# 4. Set Zsh as Default Shell
# Checks if the current user's shell is already zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to Zsh..."
    # This might ask for your password
    chsh -s "$(which zsh)"
    echo "✅ Shell changed. Log out and back in for it to take effect."
else
    echo "✅ Zsh is already the default shell."
fi

echo "--- Zsh Setup Complete ---"
